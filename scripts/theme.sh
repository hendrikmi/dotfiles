#!/usr/bin/env bash

# theme.sh — flip the whole setup between Nord and Nord Light.
#
# Ghostty has no CLI to reload its config, only a keybinding, so the terminal
# is repainted with OSC sequences: 4 for the sixteen palette slots, 10/11/12
# for foreground, background and cursor. That takes effect immediately and
# needs no reload. theme.conf is rewritten alongside so new windows match.
#
# herdr has no config includes either, so its theme block is regenerated
# between markers and the running server is told to reload.
#
# Neovim is not signalled from here; it reads the state file on startup and
# has its own <leader>tt to flip a running instance.

set -euo pipefail

root="${DOTFILES:-$HOME/git/dotfiles}"
state="${XDG_STATE_HOME:-$HOME/.local/state}/theme-mode"

mode="${1:-toggle}"
if [[ $mode == toggle ]]; then
  [[ -r $state && $(<"$state") == light ]] && mode=dark || mode=light
fi
[[ $mode == dark || $mode == light ]] || { echo "usage: theme.sh [dark|light|toggle]" >&2; exit 64; }

ghostty_theme="$root/ghostty/themes/nord-neutral"
[[ $mode == light ]] && ghostty_theme="$root/ghostty/themes/nord-light-neutral"

# Repaint the running terminal. Inside tmux the sequences need wrapping so
# they reach Ghostty rather than being swallowed; allow-passthrough is on.
emit() {
  if [[ -n ${TMUX:-} ]]; then
    printf '\ePtmux;\e\e]%s\e\e\\\e\\' "$1"
  else
    printf '\e]%s\e\\' "$1"
  fi
}

while IFS= read -r line; do
  case $line in
    palette*) emit "4;${line#*= }" ;;
    foreground*) emit "10;${line#*= }" ;;
    background*) emit "11;${line#*= }" ;;
    cursor-color*) emit "12;${line#*= }" ;;
  esac
done < "$ghostty_theme"

# Persist for new windows.
printf '# Rewritten by scripts/theme.sh\ntheme = %s\n' "$(basename "$ghostty_theme")" \
  > "$root/ghostty/theme.conf"

# starship: one line selects the palette.
sed -i '' -e "s/^palette = .*/palette = \"$( [[ $mode == light ]] && echo nord-light || echo nord )\"/" \
  "$root/starship/starship.toml"

# herdr: regenerate the managed block, then reload the running server.
herdr_conf="$root/herdr/config.toml"
blockfile=$(mktemp "${TMPDIR:-/tmp}/herdr-theme.XXXXXX")
trap 'rm -f "$blockfile"' EXIT

if [[ $mode == light ]]; then
  cat > "$blockfile" <<'EOF'
[theme]
name = "terminal"
auto_switch = false

[theme.custom]
panel_bg = "reset"
surface_dim = "reset"
surface0 = "#D7D7D7"
surface1 = "#C8C8C8"
text = "#474747"
subtext0 = "#6A6A6A"
overlay1 = "#8A8A8A"
overlay0 = "#9E9E9E"
accent = "#537781"
blue = "#5C748C"
teal = "#537781"
red = "#AC575F"
green = "#667756"
yellow = "#826F4A"
mauve = "#856980"
peach = "#9B6452"
EOF
else
  cat > "$blockfile" <<'EOF'
[theme]
name = "nord"
auto_switch = false

[theme.custom]
panel_bg = "reset"
surface_dim = "reset"
text = "#F7F7F7"
subtext0 = "#E7E7E7"
overlay1 = "#6D6D6D"
overlay0 = "#555555"
EOF
fi

# Written next to the config so the rename stays on one filesystem. Both
# temporaries are cleaned up even if awk fails, or they pile up in the repo.
tmp=$(mktemp "${herdr_conf}.XXXXXX")
trap 'rm -f "$blockfile" "$tmp"' EXIT
awk -v bf="$blockfile" '
  /^# >>> theme \(managed\)$/ { print; while ((getline l < bf) > 0) print l; close(bf); skip = 1; next }
  /^# <<< theme \(managed\)$/ { skip = 0 }
  !skip { print }
' "$herdr_conf" > "$tmp"
mv "$tmp" "$herdr_conf"
herdr server reload-config >/dev/null 2>&1 || true

mkdir -p "$(dirname "$state")"
echo "$mode" > "$state"
echo "theme → $mode"
