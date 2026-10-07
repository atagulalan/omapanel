#!/usr/bin/env python3
"""Generate/read OmaPanel monochrome icons; app descriptors arrive as JSON on stdin."""
import argparse
import json
import sys
from icon_store import prompt_for, scan


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--refresh', action='store_true', help='Recheck all source icons and regenerate offline fallbacks')
    parser.add_argument('--notify', action='store_true', help='Notify about missing/stale agent icons when agent overrides are used')
    parser.add_argument('--prompt', action='store_true', help='Include the prompt for missing/stale agent icons')
    args = parser.parse_args()
    apps = json.load(sys.stdin)
    if not isinstance(apps, list):
        raise ValueError('Expected an application descriptor array')
    result = scan(apps, args.refresh, args.notify)
    if args.prompt:
        result['prompt'] = prompt_for(result)
    print(json.dumps(result, ensure_ascii=False))


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError) as error:
        print(json.dumps({'error': str(error)}))
        sys.exit(1)
