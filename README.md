# My dotfiles

## MacOS Setup

Install essential software

- [Homebrew](https://brew.sh/) - Package manager for MacOS

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- [iTerm2](https://formulae.brew.sh/cask/iterm2) - Terminal emulator app

```bash
brew install --cask iterm2
```

- [Neovim](https://formulae.brew.sh/formula/neovim) - Vim text editor

```bash
brew install neovim
```

- [ripgrep](https://formulae.brew.sh/formula/ripgrep) - Search tool like grep. Enables live grep for the Telescope Neovim plugin.

```bash
brew install ripgrep
```

- Hack Nerd Font

```bash
brew install --cask font-hack-nerd-font
```

- [tmux](https://formulae.brew.sh/formula/tmux) - Terminal multiplexer

```bash
brew install tmux
```

Plugin manager for tmux

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Enable key repeats globally. This will enable pressing and holding 'hjkl' in JupterLab's vim mode, for instance.

```
defaults write -g ApplePressAndHoldEnabled -bool false
```
