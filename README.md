# Dotfiles

My config files for maintaining a consistent dev environment across machines.

![screenshot](img/nvim-demo.png)

> [!NOTE]
> The screenshot above is outdated and does not reflect the current setup.

## Essential Tools

- **Editor**: [NeoVim](https://neovim.io/), with a lightweight [Vim](https://www.vim.org/) fallback config (no dependencies) for maximum portability.
- **Multiplexer**: [Herdr](https://herdr.dev/), my daily driver since it is agent-first and a lot of my work these days runs through coding agents. [Tmux](https://github.com/tmux/tmux/wiki) stays as a fallback, it has served me well for years. Both are configured to share the same muscle memory, so switching between them is seamless.
- **Main Terminal**: [Ghostty](https://ghostty.org/) (Previously: [WezTerm](https://wezfurlong.org/wezterm/index.html))
- **Shell Prompt**: [Starship](https://starship.rs/)
- **Color Theme**: [Nord](https://www.nordtheme.com/docs/colors-and-palettes) across all tools.
- **Window Management**: [Rectangle](https://github.com/rxhanson/Rectangle) + [Karabiner-Elements](https://karabiner-elements.pqrs.org/) for keyboard-driven window resizing and app switching.
- **File Manager**: [Yazi](https://yazi-rs.github.io/) (Previously: [Ranger](https://github.com/ranger/ranger))
- **Coding Agent**: [Claude Code](https://claude.com/claude-code), see [Claude Code](#claude-code) below.

> [!NOTE]
> This repo also includes the config for VSCode, which I no longer actively use. I keep it around as reference and for easy reactivation, its symlink and Brewfile entries are simply commented out.

## Custom Window Management

I find macOS window management extremely frustrating: Repeatedly pressing Cmd+Tab to switch apps or having to reach for the mouse to click and drag. It's painfully slow and breaks my flow. To streamline my workflow, I built a custom setup using [Karabiner-Elements](https://karabiner-elements.pqrs.org/) and [Rectangle](https://rectangleapp.com/). Together, they let me manage windows and switch apps with minimal mental overhead, at maxium speed, entirely from the keyboard. Here's how it works:

The `Tab` key acts as a regular `Tab` when tapped, but when held it becomes a modifier (hyperkey) that unlocks two layers:

- **Window layer** (`Tab + W + ...`): Resize and position windows via Rectangle. E.g. `Tab + W + H` for left half, `Tab + W + L` for right half.
- **Expose layer** (`Tab + E + ...`): Jump directly to a specific app. E.g. `Tab + E + J` for browser, `Tab + E + K` for terminal.

## Claude Code

The `claude/` directory holds global instructions (`CLAUDE.md`), settings, keybindings, and a status line script. Each file is symlinked individually into `~/.claude/`, because that directory also stores session state and credentials that must never be versioned.

`CLAUDE.md` ends with two imports that are not part of this repo, `@~/.claude/work.md` and `@~/.claude/private.md`, and an absent import silently resolves to nothing. `private.md` comes from the private counterpart below. `work.md` stays machine-local, so a fresh work machine needs it copied over by hand.

Plugins are restored from the `enabledPlugins` entry in `settings.json`. Skills, subagents, commands, and hooks come from the private counterpart.

## Private Counterpart

Anything personal or otherwise not publishable lives in `dotfiles-private`, cloned next to this repo at `../dotfiles-private`. Same structure as here, one directory per tool, driven by its own `symlinks.conf`. Today that is only Claude Code, but nothing about the setup is specific to it.

Its `symlinks.sh` reads that config the way `scripts/symlinks.sh` reads the one here, with one addition: a source ending in `/*` links every entry inside a directory rather than the directory itself. That form is needed for targets like `~/.claude/skills`, which also hold Homebrew-managed and separately installed content that a directory-level symlink would hide.

`install.sh` calls the script at the end when the repo is present and skips the step otherwise, so a machine without it still installs cleanly.

## Setup

Clone this repo, and the private counterpart next to it if you have access to it:

```bash
git clone https://github.com/hendrikmi/dotfiles.git
git clone https://github.com/hendrikmi/dotfiles-private.git
```

Then run the installer from the repo root and follow the on-screen prompts:

```bash
./install.sh
```

The private repo has to be in place before this runs, otherwise the installer skips it and you need a separate `../dotfiles-private/symlinks.sh` afterwards.

## Uninstalling

To remove all symlinks created by the installation script:

```bash
./scripts/symlinks.sh --delete
```

This only removes the symlinks, not the actual config files, so you can easily revert if needed. The private counterpart is removed separately with `../dotfiles-private/symlinks.sh --delete`.

## Adding New Dotfiles and Software

### Dotfiles

1. Place the config file in the appropriate directory within this repo.
2. Add a symlink entry in `symlinks.conf`.
3. If needed, update `install.sh` to handle any additional setup.

### Software Installation

Software is managed via Homebrew. To add a formula or cask, update `homebrew/Brewfile` and run `./scripts/brew-install.sh`.

To pin a specific version, create a local tap with `brew tap-new <user>/local` and place the formula there. Homebrew rejects formulae and casks that live outside a tap, so a plain `.rb` file inside this repo cannot be installed.
