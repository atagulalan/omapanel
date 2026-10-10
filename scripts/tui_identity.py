"""Resolve marked TUI windows without inspecting titles or ordinary terminals."""
import json
import os
from pathlib import Path
import re
import shlex


def marked(value):
    return value.startswith('org.omarchy.') or value in ('TUI.tile', 'TUI.float')


def commands(exec_string):
    try:
        tokens = shlex.split(exec_string)
    except ValueError:
        return []
    if '-e' in tokens:
        tokens = tokens[tokens.index('-e') + 1:]
    elif tokens and Path(tokens[0]).name == 'omarchy-launch-tui':
        tokens = [v for v in tokens[1:] if not v.startswith('--app-id=')]
    if len(tokens) > 2 and Path(tokens[0]).name in ('bash', 'sh', 'zsh') and tokens[1] == '-c':
        return commands(tokens[2])
    if tokens and tokens[0] == 'env':
        tokens = [v for v in tokens[1:] if '=' not in v and not v.startswith('-')]
    if not tokens:
        return []
    command = Path(tokens[0]).name
    # The stock Docker launcher execs lazydocker after acquiring daemon access.
    return [command, 'lazydocker'] if command == 'omarchy-launch-docker-tui' else [command]


def process_names(pid, proc=Path('/proc')):
    queue, seen, result = [(pid, 0)], set(), []
    while queue and len(seen) < 64:
        current, depth = queue.pop(0)
        if current in seen or depth > 4:
            continue
        seen.add(current)
        directory = proc / str(current)
        try:
            if depth == 0 and directory.stat().st_uid != os.getuid():
                continue
            names = [directory.joinpath('comm').read_text().strip()]
            try:
                args = directory.joinpath('cmdline').read_bytes().split(b'\0')
            except OSError:
                args = []
            if args and args[0]:
                names.append(Path(os.fsdecode(args[0])).name)
                if names[-1] in ('node', 'nodejs', 'python3', 'bash', 'sh') and len(args) > 1 and args[1].startswith(b'/'):
                    script = os.fsdecode(args[1])
                    names.append(Path(script).stem)
                    if '/@anthropic-ai/claude-code/' in script:
                        names.append('claude')
            result.extend(name for name in names if name and name not in result)
            children = directory.joinpath('task', str(current), 'children').read_text().split()
            queue.extend((int(child), depth + 1) for child in children)
        except (OSError, ValueError):
            continue
    return result


def agent_entries(omarchy):
    path = omarchy / 'default/omarchy/omarchy-menu.jsonc'
    try:
        raw = path.read_text()
        raw = re.sub(r'("(?:\\.|[^"\\])*")|//[^\n]*|/\*.*?\*/', lambda m: m[1] or '', raw, flags=re.S)
        raw = re.sub(r'("(?:\\.|[^"\\])*")|,\s*(?=[}\]])', lambda m: m[1] or '', raw)
        menu = json.loads(raw)
    except (OSError, ValueError):
        return []
    result = []
    for identifier, record in menu.items():
        prefix = 'setup.default.agent.'
        if not identifier.startswith(prefix):
            continue
        command = identifier[len(prefix):]
        if not re.fullmatch(r'[a-z0-9-]+', command):
            continue
        icon = omarchy / 'shell/plugins/agents/assets' / (command + '.svg')
        if not icon.is_file():
            continue
        light = icon.with_name(command + '-light.svg')
        result.append(dict(id='omapanel.tui.' + command, name=record.get('label', command),
                           icon=str(icon), lightIcon=str(light) if light.is_file() else '', tui=True,
                           launch='omarchy-launch-tui --app-id=org.omarchy.agent ' + shlex.quote(command),
                           commands=[command]))
    return result


def resolve(windows, entries, agents, proc=Path('/proc')):
    catalog = [dict(e, tui=True, commands=commands(e.get('exec', ''))) for e in entries
               if re.search(r'(?:xdg-terminal-exec|omarchy-launch-tui)(?:\s|$)', e.get('exec', '')) or e.get('terminal')]
    desktop_commands = {name for entry in catalog for name in entry["commands"]}
    catalog += [entry for entry in agents if not any(name in desktop_commands for name in entry["commands"])]
    identities = {}
    for window in windows:
        cls = window.get('class', '')
        if not marked(cls):
            continue
        names = process_names(int(window.get('pid', 0)), proc)
        suffix = cls.removeprefix('org.omarchy.')
        if cls.startswith('org.omarchy.') and suffix != 'agent':
            names.insert(0, suffix)
        for name in names:
            matches = [entry for entry in catalog if name in entry['commands']]
            if len(matches) == 1:
                identities[window['key']] = matches[0]['id']
                break
    return dict(windows=identities, entries={entry['id']: entry for entry in catalog})
