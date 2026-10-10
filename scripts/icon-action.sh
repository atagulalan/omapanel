#!/bin/sh
# Bootstrap with shell builtins so missing Python produces actionable feedback.
if ! command -v python3 >/dev/null 2>&1; then
  printf '%s\n' '{"ok":false,"error":"Python 3 is required. Install its official core repository package, then retry: omarchy pkg add python"}'
  exit 1
fi
script_dir=${0%/*}
case "$1" in
  generate) shift; exec python3 -B "$script_dir/stylized-icons.py" "$@" ;;
  agent|clipboard) exec python3 -B "$script_dir/icon-requirements.py" "$1" ;;
  *) printf '%s\n' '{"ok":false,"error":"Unknown icon action"}'; exit 1 ;;
esac
