# zsh Options
setopt HIST_IGNORE_ALL_DUPS

#zmodload zsh/zprof # > Start of code to profile


# Custom functions 
[ -f "$HOME/.config/zsh/functions.zsh" ] && source "$HOME/.config/zsh/functions.zsh"

# Custom zsh
[ -f "$HOME/.config/zsh/custom.zsh" ] && source "$HOME/.config/zsh/custom.zsh"

# Zsh Plugin Settings
[ -f "$HOME/.config/zsh/plugin_settings.zsh" ] && source "$HOME/.config/zsh/plugin_settings.zsh"

# Aliases
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"

# Work
[ -f "$HOME/.config/zsh/work.zsh" ] && source "$HOME/.config/zsh/work.zsh"

#zprof # > End of code to profile
