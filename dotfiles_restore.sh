#!/bin/bash

# Set the backup directory name
backup_base_dir="${HOME}/code/dotfiles"

# Define a function to copy a file from the backup directory to its original location
copy_from_backup() {
    src_path="${backup_base_dir}/$1"
    target_path="$2"

    # Copy the file/directory back to its original location
    cp -R "${src_path}" "${HOME}/${target_path}"
}

# Call the copy_from_backup function for each dotfile or directory to restore,
# specifying the source file in the backup directory and the target path in your home directory
copy_from_backup "zsh/.zshrc" ".zshrc"
copy_from_backup "nvim/init.lua" ".config/nvim/init.lua"
copy_from_backup "nvim/lua" ".config/nvim/lua"
copy_from_backup "tmux/.tmux.conf" ".tmux.conf"
copy_from_backup "iterm" ".iterm"

echo "Dotfiles restored from ${backup_base_dir} directory."

