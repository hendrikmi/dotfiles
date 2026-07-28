#!/bin/bash

. scripts/utils.sh
. scripts/prerequisites.sh
. scripts/brew-install.sh
. scripts/osx-defaults.sh
. scripts/symlinks.sh

info "Dotfiles intallation initialized..."
read -p "Install apps? [y/n] " install_apps
read -p "Overwrite existing dotfiles? [y/n] " overwrite_dotfiles

if [[ "$install_apps" == "y" ]]; then
    printf "\n"
    info "===================="
    info "Prerequisites"
    info "===================="

    install_xcode
    install_homebrew

    printf "\n"
    info "===================="
    info "Apps"
    info "===================="

    run_brew_bundle
fi

printf "\n"
info "===================="
info "OSX System Defaults"
info "===================="

register_keyboard_shortcuts
apply_osx_system_defaults

printf "\n"
info "===================="
info "Terminal"
info "===================="

info "Adding .hushlogin file to suppress 'last login' message in terminal..."
touch ~/.hushlogin

printf "\n"
info "===================="
info "Symbolic Links"
info "===================="

chmod +x ./scripts/symlinks.sh
if [[ "$overwrite_dotfiles" == "y" ]]; then
    warning "Deleting existing dotfiles..."
    ./scripts/symlinks.sh --delete --include-files
fi
./scripts/symlinks.sh --create

# The private counterpart lives in its own repo and is cloned next to this one.
# When it is absent, this step is simply skipped.
private_dotfiles="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles-private"
if [ -d "$private_dotfiles" ]; then
    "$private_dotfiles/symlinks.sh" --create
else
    info "No private dotfiles at $private_dotfiles, skipping."
fi

success "Dotfiles set up successfully."
