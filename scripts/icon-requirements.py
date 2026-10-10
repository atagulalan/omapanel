#!/usr/bin/env python3
import json
import sys
from icon_requirements import requirements

result = requirements(sys.argv[1])
print(json.dumps(result))
sys.exit(0 if result['ok'] else 1)
