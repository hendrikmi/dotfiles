#!/usr/bin/env bash

# theme.sh — flip the whole setup between light and dark.
#
# The macOS appearance is the single switch. Everything else already knows how
# to follow it, so this does not touch colors directly:
#
#   Ghostty  theme = dark:...,light:... follows the appearance natively
#   herdr    auto_switch queries the host terminal and re-themes itself
#   Neovim   reads the state file, woken by SIGUSR1
#   Starship has no such mechanism, so its palette line is rewritten
#
# Earlier attempts drove Ghostty with OSC sequences instead. That cannot work
# from inside a herdr pane: herdr intercepts OSC 10/11/12 and answers them
# from its own theme rather than passing them on.

set -euo pipefail

root="${DOTFILES:-$HOME/git/dotfiles}"
state="${XDG_STATE_HOME:-$HOME/.local/state}/theme-mode"

case "${1:-toggle}" in
  toggle)
    [[ $(osascript -e 'tell app "System Events" to tell appearance preferences to get dark mode') == true ]] \
      && mode=light || mode=dark
    ;;
  light | dark) mode=$1 ;;
  *) echo "usage: theme.sh [dark|light|toggle]" >&2; exit 64 ;;
esac

[[ $mode == dark ]] && want=true || want=false
osascript -e "tell app \"System Events\" to tell appearance preferences to set dark mode to $want"

# Starship selects a palette by name and has no appearance hook.
sed -i '' -e "s/^palette = .*/palette = \"$([[ $mode == light ]] && echo nord-light || echo nord)\"/" \
  "$root/starship/starship.toml"

mkdir -p "$(dirname "$state")"
echo "$mode" > "$state"

# Nudge running Neovim instances; they re-read the state file on SIGUSR1.
pkill -USR1 -x nvim 2>/dev/null || true

echo "theme → $mode"
