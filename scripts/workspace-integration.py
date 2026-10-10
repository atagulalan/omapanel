#!/usr/bin/env python3
"""Reversibly coordinate OmaPanel and the stock workspace widget through Omarchy IPC."""
import argparse
import fcntl
import json
import os
from pathlib import Path
import subprocess
from icon_store import atomic_json

PANEL = 'atagulalan.omapanel'
WORKSPACES = 'omarchy.workspaces'


def command(*arguments):
    result = subprocess.run(list(arguments), capture_output=True, text=True, check=True, timeout=12)
    return result.stdout.strip()


def config():
    return json.loads(command('omarchy-shell', 'shell', 'listShellConfig'))


def locations(configuration, identifier):
    result = []
    for section in ('left', 'center', 'right'):
        entries = configuration.get('bar', {}).get('layout', {}).get(section, [])
        for index, entry in enumerate(entries):
            if (entry.get('id') if isinstance(entry, dict) else entry) == identifier:
                result.append({'section': section, 'index': index, 'entry': entry})
    return result


def panel_setting(key, value):
    command('omarchy', 'bar', 'set', PANEL, key, json.dumps(value), '--json')


def restore(snapshot):
    current = locations(config(), WORKSPACES)
    if snapshot.get('entries'):
        location = snapshot['entries'][0]
        command('omarchy', 'plugin', 'enable', WORKSPACES,
                '--section', location['section'], '--index', str(location['index']))
        entry = location['entry']
        if isinstance(entry, dict):
            for key, value in entry.items():
                if key != 'id':
                    command('omarchy', 'bar', 'set', WORKSPACES, key, json.dumps(value), '--json')
    elif current:
        # Preserve a switcher the user independently enabled while integrated.
        return


def transition(enable, state_file):
    try:
        snapshot = json.loads(state_file.read_text())
    except (OSError, ValueError):
        snapshot = None
    if enable:
        configuration = config()
        pins = locations(configuration, PANEL)
        entry = pins[0]['entry'] if pins and isinstance(pins[0]['entry'], dict) else {}
        if not pins or entry.get('groupRunningByWorkspace', True) is not True:
            raise ValueError('Enable Group by workspace before integration.')
        if snapshot is None:
            snapshot = {'entries': locations(configuration, WORKSPACES)}
            atomic_json(state_file, snapshot)
        try:
            command('omarchy', 'plugin', 'disable', WORKSPACES)
            panel_setting('integrateWorkspaces', True)
        except (OSError, ValueError, subprocess.SubprocessError):
            restore(snapshot)
            raise
    else:
        if snapshot:
            restore(snapshot)
        panel_setting('integrateWorkspaces', False)
        state_file.unlink(missing_ok=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=('enable', 'disable'))
    args = parser.parse_args()
    directory = Path(os.environ.get('XDG_STATE_HOME', Path.home() / '.local/state')) / 'omapanel'
    directory.mkdir(parents=True, exist_ok=True)
    with (directory / 'workspace-integration.lock').open('w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        transition(args.action == 'enable', directory / 'workspace-integration.json')
    print(json.dumps({'ok': True}))


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print(json.dumps({'error': str(error)}))
        raise SystemExit(1)
