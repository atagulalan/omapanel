#!/usr/bin/env python3
"""Generate/read OmaPanel monochrome icons; app descriptors arrive as JSON on stdin."""
import argparse
import json
import sys
from icon_store import prompt_for, scan
from icon_requirements import requirements


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--refresh', action='store_true', help='Recheck all source icons and regenerate offline fallbacks')
    parser.add_argument('--notify', action='store_true', help='Notify about missing/stale agent icons when agent overrides are used')
    parser.add_argument('--prompt', action='store_true', help='Include the prompt for missing/stale agent icons')
    args = parser.parse_args()
    tools = requirements('tools')
    if not tools['ok']:
        print(json.dumps(tools)); return 1
    agent = requirements('agent') if args.prompt else {'ok': True, 'note': ''}
    if not agent['ok']:
        print(json.dumps(agent)); return 1
    apps = json.load(sys.stdin)
    if not isinstance(apps, list):
        raise ValueError('Expected an application descriptor array')
    result = scan(apps, args.refresh, args.notify)
    if args.prompt:
        result['prompt'] = prompt_for(result)
    result["agentNote"] = agent.get("note", "")
    print(json.dumps(result, ensure_ascii=False))
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (OSError, ValueError) as error:
        print(json.dumps({'error': str(error)}))
        sys.exit(1)
