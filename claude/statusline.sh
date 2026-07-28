#!/usr/bin/env bash
# Claude Code status line: directory, git branch, model, context window used.

input=$(cat)

dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(printf '%s' "$input" | jq -r '.model.display_name // "?"')
used=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
branch=$(git --no-optional-locks -C "$dir" branch --show-current 2>/dev/null)

reset=$'\033[0m'
dim=$'\033[2m'
blue=$'\033[34m'
magenta=$'\033[35m'
cyan=$'\033[36m'
sep="${dim} │ ${reset}"

out="${blue} $(basename "$dir")${reset}"
[ -n "$branch" ] && out+="${sep}${magenta} ${branch}${reset}"
out+="${sep}${cyan}󰧑 ${model}${reset}"

if [ -n "$used" ]; then
    pct=${used%.*}
    [ "$pct" -gt 100 ] && pct=100
    if [ "$pct" -lt 50 ]; then
        color=$'\033[32m'
    elif [ "$pct" -lt 80 ]; then
        color=$'\033[33m'
    else
        color=$'\033[31m'
    fi

    filled=$((pct / 10))
    bar="${color}"
    for ((i = 0; i < filled; i++)); do bar+="▰"; done
    bar+="${dim}"
    for ((i = filled; i < 10; i++)); do bar+="▱"; done

    out+="${sep}${bar}${reset}${color} ${pct}%${reset}"
fi

printf '%s' "$out"
