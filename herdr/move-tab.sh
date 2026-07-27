#!/usr/bin/env bash

# move-tab.sh — herdr equivalent of tmux `swap-window -d -t :{-1,+1}`.
# herdr has no move_tab keybinding action; reordering only exists as the
# `tab.move` socket method, so shell out to it from a [[keys.command]].
# Requires `jq` and `nc`.

set -euo pipefail

dir="${1:?usage: move-tab.sh <left|right>}"
herdr="${HERDR_BIN_PATH:-herdr}"
sock="${HERDR_SOCKET_PATH:-$HOME/.config/herdr/herdr.sock}"
tab="${HERDR_ACTIVE_TAB_ID:-}"
ws="${HERDR_ACTIVE_WORKSPACE_ID:-}"

[ -n "$tab" ] && [ -n "$ws" ] || exit 0

read -r pos count < <(
  "$herdr" tab list --workspace "$ws" \
    | jq -r --arg t "$tab" '.result.tabs | "\(map(.tab_id) | index($t)) \(length)"'
)

[ "$pos" != "null" ] || exit 0

# insert_index is a slot in the pre-move list (insert *before* the tab
# currently at that index), so moving right needs pos+2, not pos+1.
case "$dir" in
  left)  [ "$pos" -gt 0 ] || exit 0; target=$((pos - 1)) ;;
  right) [ "$pos" -lt $((count - 1)) ] || exit 0; target=$((pos + 2)) ;;
  *) echo "move-tab.sh: unknown direction: $dir" >&2; exit 2 ;;
esac

printf '{"id":"move-tab","method":"tab.move","params":{"tab_id":"%s","insert_index":%d}}\n' \
  "$tab" "$target" | nc -U "$sock" >/dev/null
