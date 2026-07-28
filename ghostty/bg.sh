#!/usr/bin/env bash

# bg.sh — step the terminal background brightness.
#
# Ghostty has no CLI to reload its config, only a keybinding, so this does
# both halves: an OSC 11 sequence repaints the running terminal immediately,
# and background.conf is rewritten so new windows come up at the same level.
#
# Neovim, herdr and tmux all leave their background unset, so they follow
# whatever the terminal is showing.

set -euo pipefail

# Level 1 is the darkest. Each step is roughly a third brighter, which on a
# glossy panel moves reflections from very visible to barely noticeable.
LEVELS=(
  "#282C35" # 12.5 nits, 57% reflection
  "#30353F" # 17.7 nits, 41%
  "#393E49" # 24.0 nits, 30%
  "#434955" # 33.1 nits, 22%
  "#4E5462" # 44.2 nits, 16%
)

conf="${GHOSTTY_BG_CONF:-$HOME/.config/ghostty/background.conf}"
state="${XDG_STATE_HOME:-$HOME/.local/state}/ghostty-bg-level"

usage() {
  echo "usage: bg.sh [up|down|1-${#LEVELS[@]}]" >&2
  exit 64
}

current=1
[[ -r $state ]] && current=$(<"$state")
[[ $current =~ ^[0-9]+$ ]] || current=1

case "${1:-up}" in
  up)   next=$(( current % ${#LEVELS[@]} + 1 )) ;;
  down) next=$(( (current + ${#LEVELS[@]} - 2) % ${#LEVELS[@]} + 1 )) ;;
  [0-9]*)
    next=$1
    (( next >= 1 && next <= ${#LEVELS[@]} )) || usage
    ;;
  *) usage ;;
esac

color=${LEVELS[$((next - 1))]}

# Repaint the running terminal. Inside tmux the sequence needs to be wrapped
# so it reaches Ghostty instead of being swallowed; allow-passthrough is on.
if [[ -n ${TMUX:-} ]]; then
  printf '\ePtmux;\e\e]11;%s\e\e\\\e\\' "$color"
else
  printf '\e]11;%s\e\\' "$color"
fi

# Persist for new windows. Written atomically so a half-written file can
# never break Ghostty's config parsing.
tmp=$(mktemp "${conf}.XXXXXX")
cat >"$tmp" <<EOF
# Background brightness, rewritten by ghostty/bg.sh.
# Included from ghostty/config so the level survives new windows.
background = $color
EOF
mv "$tmp" "$conf"

mkdir -p "$(dirname "$state")"
echo "$next" >"$state"

echo "background level $next/${#LEVELS[@]} → $color"
