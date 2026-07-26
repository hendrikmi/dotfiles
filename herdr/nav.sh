#!/usr/bin/env bash

# nav.sh — herdr side of seamless Ctrl+h/j/k/l navigation between herdr panes
# and (Neo)vim splits (editor side: nvim/lua/plugins/navigator.lua).
# Forwards the key to the pane if Vim runs in it, otherwise moves herdr focus.
# Requires `jq` for the Vim detection.

set -euo pipefail

dir="${1:?usage: nav.sh <left|down|up|right>}"
herdr="${HERDR_BIN_PATH:-herdr}"
pane="${HERDR_ACTIVE_PANE_ID:-}"

case "$dir" in
  left)  key="ctrl+h" ;;
  down)  key="ctrl+j" ;;
  up)    key="ctrl+k" ;;
  right) key="ctrl+l" ;;
  *) echo "nav.sh: unknown direction: $dir" >&2; exit 2 ;;
esac

# Foreground process names that mean "Vim is in control of this pane"
vim_re='^g?(view|l?n?vim?x?)(diff)?$'

forward=0
if [ -n "$pane" ] && command -v jq >/dev/null 2>&1; then
  if "$herdr" pane process-info --current 2>/dev/null \
    | jq -e --arg vim "$vim_re" \
        '.result.process_info.foreground_processes[]?.name
         | ascii_downcase
         | select(test($vim))' >/dev/null 2>&1; then
    forward=1
  fi
fi

if [ "$forward" -eq 1 ]; then
  exec "$herdr" pane send-keys "$pane" "$key"
else
  exec "$herdr" pane focus --direction "$dir" --current
fi
