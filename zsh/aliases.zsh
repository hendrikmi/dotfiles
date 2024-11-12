#!/bin/zsh
#
# .aliases - Set whatever shell aliases you want.
#

# -------------------------------------------------------------------
# System commands 
# -------------------------------------------------------------------
alias shutdown='sudo shutdown now'
alias restart='sudo reboot'
alias suspend='sudo pm-suspend'
alias sleep='pmset sleepnow'
alias c='clear'
alias e='exit'
alias vi='vim' # Mask builtin with better default

# -------------------------------------------------------------------
# Git
# -------------------------------------------------------------------
alias ga='git add'
alias gp='git push'
alias gl='git log --all --decorate --oneline --graph'
alias gs='git status'
alias gss="git status -s"
alias gd='git diff'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gra='git remote add'
alias grr='git remote rm'
alias gp='git pull'		
alias gpu='git push'
# Useful for large repos as only pulls changes for that one branch
# Instead of a full fetch
alias gpo='git pull origin'
alias gcl='git clone'
alias gf='git fetch'
alias gbranches='git reflog | grep checkout | cut -d '\'' '\'' -f 8 | awk '\''!seen[$0]++'\'' | head ${1} | cat -n'
alias glog='git log --graph --oneline --all'

# FZF Commands
alias gafzf='git ls-files -m -o --exclude-standard | grep -v "__pycache__" | fzf -m --print0 | xargs -0 -o -t git add' # Git add with fzf
alias grmfzf='git ls-files -m -o --exclude-standard | fzf -m --print0 | xargs -0 -o -t git rm' # Git rm with fzf
alias grfzf='git diff --name-only | fzf -m --print0 | xargs -0 -o -t git restore' # Git restore with fzf
alias grsfzf='git diff --name-only | fzf -m --print0 | xargs -0 -o -t git restore --staged' # Git restore --staged with fzf
alias gcofzf='git branch | fzf | xargs git checkout' # Select branch with fzf

# -------------------------------------------------------------------
# Updating built-ins
# -------------------------------------------------------------------
eval $(thefuck --alias)
# Use oxide instead of cd
alias cd=z
# Use bat instead of cat
alias cat=bat

alias del='echo Moving to ~/.Trash/ ...; mv -i $* ~/.Trash/'
# alias cdf='eval `osascript /Applications/Utilities/OpenTerminal.app/Contents/Resources/Scripts/OpenTerminal.scpt`'
#alias ls='ls -FG'
#alias dir='ls -FGl'
#alias ll="ls -l"

# Safe options, this could be dangerous for other apps that aren't expecting these
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

alias python='python3'
alias pip='pip3'

# -------------------------------------------------------------------
# Misc 
# -------------------------------------------------------------------
# Ranger
alias r=". ranger"

# Better ls
alias ls="eza --all --icons=always"

# Misc 
alias please='sudo'
alias zshrc='code "${ZDOTDIR:-$HOME}"/.zshrc'
alias zdot='cd ${ZDOTDIR:-~}'

# fix common typos
alias quit='exit'
alias cd..='cd ..'

# -------------------------------------------------------------------
# Neovim
# -------------------------------------------------------------------
# If poetry is installed and an environment exists, run "poetry run nvim"
# poetry_run_nvim() {
#   if command -v poetry >/dev/null 2>&1 && [ -f "poetry.lock" ]; then
#     poetry run nvim "$@"
#   else
#     nvim "$@"
#   fi
# }
# alias vi='poetry_run_nvim'
# alias v='poetry_run_nvim'