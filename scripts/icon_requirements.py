"""Read-only prerequisite checks; never install packages or run generation requests."""
import os
from pathlib import Path
import re
import shutil
import subprocess

TOOLS = {'magick': ('imagemagick', 'extra'), 'wl-copy': ('wl-clipboard', 'extra')}


def run(command, timeout=8):
    return subprocess.run(command, capture_output=True, text=True, timeout=timeout,
                          env=dict(os.environ, NO_COLOR='1', LC_ALL='C', MISE_OFFLINE='1', MISE_AUTO_INSTALL='0'))


def package_help(packages):
    names = list(dict.fromkeys(packages))
    if not shutil.which('pacman'):
        return 'Could not verify official repository packages. Restore the Arch package database and retry.'
    for package in names:
        result = run(['pacman', '-Si', package])
        repositories = re.findall(r'^Repository\s*:\s*(\S+)', result.stdout, re.M)
        if not repositories or repositories[0] not in ('core', 'extra'):
            return ('The required package ' + package + ' is not available from the configured official core/extra repositories. '
                    'Restore the official repositories before installing it; no AUR or third-party package is suggested.')
    return 'Install the official repository package(s), then retry:\nomarchy pkg add ' + ' '.join(names)


def tools_ready(clipboard=False):
    required = ['wl-copy'] if clipboard else ['magick']
    missing = [TOOLS[name][0] for name in required if not shutil.which(name)]
    if missing:
        return dict(ok=False, error=package_help(missing))
    if not clipboard and run(['magick', '-version']).returncode:
        return dict(ok=False, error='ImageMagick could not start. Repair its installation, then retry.')
    return dict(ok=True)


def agent_ready():
    if not shutil.which('omarchy'):
        return dict(ok=False, error='The Omarchy CLI is unavailable. Restore Omarchy before generating icons with an agent.')
    selected = run(['omarchy', 'default', 'agent'])
    agent = selected.stdout.strip()
    if selected.returncode or not re.fullmatch(r'[a-z0-9-]+', agent):
        return dict(ok=False, error='Choose a default agent in Omarchy → Setup → Default Agent, or run:\nomarchy default agent <agent>\nThen finish its sign-in/provider setup and retry.')
    setup = 'Install or repair the selected agent with Omarchy:\nomarchy default agent ' + agent + '\nThen finish its sign-in/provider setup and retry.'
    executable = shutil.which(agent)
    if not executable:
        return dict(ok=False, error='The default agent ' + agent + ' is not installed.\n' + setup)
    # Stock cold wrappers may install on --version. Detect them before probing.
    try:
        with Path(executable).open('rb') as source:
            wrapper = source.read(4096)
    except OSError:
        wrapper = b''
    if b'mise use -g' in wrapper and b'exec mise' in wrapper:
        installed = run(['mise', 'which', agent, '--tool=' + agent]) if shutil.which('mise') else None
        if not installed or installed.returncode or not os.access(installed.stdout.strip(), os.X_OK):
            return dict(ok=False, error='The default agent ' + agent + ' has only an installer wrapper.\n' + setup)
        executable = installed.stdout.strip()
    if agent in ('hermes', 'openclaw'):
        installer = 'omarchy-install-' + agent + '-cli'
        if not shutil.which(installer) or run([installer, '--check']).returncode:
            return dict(ok=False, error='The default agent ' + agent + ' is not installed.\n' + setup)
    if run([executable, '--version']).returncode:
        return dict(ok=False, error='The default agent ' + agent + ' could not start.\n' + setup)
    if agent == 'codex':
        if run([executable, 'login', 'status']).returncode:
            return dict(ok=False, error='Codex is not signed in. Run:\ncodex login\nThen retry icon generation.')
    elif agent == 'claude':
        if run([executable, 'auth', 'status']).returncode:
            return dict(ok=False, error='Claude sign-in could not be verified. Run:\nclaude auth login\nThen retry icon generation.')
    else:
        return dict(ok=True, agent=agent, note='The ' + agent + ' executable is available. Before generating, finish login/provider setup in:\nomarchy agent\nThis agent has no supported automatic sign-in check in OmaPanel.')
    return dict(ok=True, agent=agent, note='')


def requirements(mode):
    try:
        return agent_ready() if mode == 'agent' else tools_ready(mode == 'clipboard')
    except (OSError, subprocess.SubprocessError):
        return dict(ok=False, error='Requirement check failed or timed out. Check the installed tools and default agent, then retry.')
