# Dotfiles

My config files for maintaining a consistent dev environment across machines.

![screenshot](img/nvim-demo.png)

## Essential Tools

- **Editor**: [NeoVim](https://neovim.io/), with a lightweight [Vim](https://www.vim.org/) fallback config (no dependencies) for maximum portability.
- **Multiplexer**: [Tmux](https://github.com/tmux/tmux/wiki)
- **Main Terminal**: [Ghostty](https://ghostty.org/) (Previously: [WezTerm](https://wezfurlong.org/wezterm/index.html))
- **Shell Prompt**: [Starship](https://starship.rs/)
- **Color Theme**: [Nord](https://www.nordtheme.com/docs/colors-and-palettes) across all tools, switchable via environment variables in `.zshenv`.
- **Window Management**: [Rectangle](https://github.com/rxhanson/Rectangle) + [Karabiner-Elements](https://karabiner-elements.pqrs.org/) for keyboard-driven window resizing and app switching.
- **File Manager**: [Yazi](https://yazi-rs.github.io/) (Previously: [Ranger](https://github.com/ranger/ranger))

> [!NOTE]
> This repo also includes configs for tools I no longer actively use (WezTerm, kitty, iTerm, VSCode, Ranger). I keep them around as reference and for easy reactivation — their symlinks and Brewfile entries are simply commented out.

## Custom Window Management

I find macOS window management extremely frustrating: Repeatedly pressing Cmd+Tab to switch apps or having to reach for the mouse to click and drag. It's painfully slow and breaks my flow. To streamline my workflow, I built a custom setup using [Karabiner-Elements](https://karabiner-elements.pqrs.org/) and [Rectangle](https://rectangleapp.com/). Together, they let me manage windows and switch apps with minimal mental overhead, at maxium speed, entirely from the keyboard. Here's how it works:

The `Tab` key acts as a regular `Tab` when tapped, but when held it becomes a modifier (hyperkey) that unlocks two layers:

- **Window layer** (`Tab + W + ...`): Resize and position windows via Rectangle. E.g. `Tab + W + H` for left half, `Tab + W + L` for right half.
- **Expose layer** (`Tab + E + ...`): Jump directly to a specific app. E.g. `Tab + E + J` for browser, `Tab + E + K` for terminal.

## Setup

To set up these dotfiles on your system, run:

```bash
./install.sh
```

Then follow the on-screen prompts.

## Uninstalling

To remove all symlinks created by the installation script:

```bash
./scripts/symlinks.sh --delete
```

This only removes the symlinks, not the actual config files, so you can easily revert if needed.

## Adding New Dotfiles and Software

### Dotfiles

1. Place the config file in the appropriate directory within this repo.
2. Add a symlink entry in `symlinks.conf`.
3. If needed, update `install.sh` to handle any additional setup.

### Software Installation

Software is managed via Homebrew. To add a formula or cask, update `homebrew/Brewfile` and run `./scripts/brew_install_custom.sh`. For pinning a specific version, find its Ruby script in the commit history of the official Homebrew GitHub repo and place it in `homebrew/custom-casks/` or `homebrew/custom-formulae/`.
