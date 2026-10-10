#!/usr/bin/env python3
"""Read window and desktop-entry descriptors; print only resolved TUI identities."""
import json
import os
from pathlib import Path
import sys
from tui_identity import agent_entries, resolve

try:
    request = json.load(sys.stdin)
    omarchy = Path(os.environ.get('OMARCHY_PATH', '/usr/share/omarchy'))
    print(json.dumps(resolve(request['windows'], request['entries'], agent_entries(omarchy))))
except (OSError, ValueError, KeyError) as error:
    print(json.dumps({'error': str(error)}))
    sys.exit(1)
