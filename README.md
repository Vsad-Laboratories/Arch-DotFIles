# ArchDotFiles

Personal Arch Linux dotfiles — Niri Wayland compositor, Neovim (LazyVim), Zsh, EWW widgets, and supporting tools.

## Overview

| Component | Description |
|-----------|-------------|
| **Niri** | Tiling Wayland compositor with custom keybinds, layout rules, and animations |
| **Neovim** | LazyVim-based setup with LSP, Treesitter, and custom keymaps |
| **EWW** | ElKowars wacky widgets — HUD with system stats (CPU, RAM, battery, clock, network) |
| **Zsh** | Modular shell config with vi-mode, fzf integration, autosuggestions, syntax highlighting |
| **Starship** | Cross-shell prompt — Vanta Black theme with git, language, and duration info |
| **Yazi** | Blazing fast terminal file manager with custom keybindings and theme |
| **Kitty** | GPU-accelerated terminal with Maple Mono NF font and Nerd Font glyph mapping |
| **WireMix** | TUI audio mixer for PipeWire/PulseWire |
| **Zen Browser** | Firefox-based browser (profiles.ini only — no browsing data) |

## Directory Structure

```
ArchDotFiles/
├── niri/                    # Niri Wayland compositor
│   ├── config.kdl           # Main config (entry point)
│   ├── modules/             # Keybinds, input, rules, startup
│   └── ui/                  # Appearance, layout, animations
├── nvim/                    # Neovim (LazyVim)
│   ├── init.lua
│   ├── lazy-lock.json       # Plugin lock file
│   └── lua/
│       ├── config/          # Options, keymaps, autocmds, lazy setup
│       └── plugins/         # Editor, langs, UI, yazi integration
├── eww/                     # EWW widgets
│   ├── eww.yuck             # Main widget definitions
│   ├── eww.scss             # Styles
│   ├── scripts/             # Widget data scripts (battery, clock, cpu, etc.)
│   ├── widgets/             # Individual widget components
│   ├── windows/             # Window geometry definitions
│   └── styles/              # SCSS stylesheets
├── zsh/                     # Zsh configuration
│   ├── .zshrc               # Main zshrc (sources modular files)
│   ├── .zshenv              # Environment variables
│   ├── aliases.zsh          # Shell aliases (eza, bat, ripgrep)
│   ├── bindings.zsh         # Vi-mode keybindings
│   ├── fzf.zsh              # FZF configuration
│   ├── plugins.zsh          # Plugin manager (autosuggestions, syntax-highlighting, vi-mode)
│   ├── prompt.zsh           # Starship prompt init
│   └── zshrc.home           # Minimal .zshrc (non-modular version)
├── starship.toml            # Starship prompt config
├── yazi/                    # Yazi file manager
│   ├── yazi.toml            # Main config
│   ├── keymap.toml          # Keybindings
│   ├── theme.toml           # Theme
│   └── package.toml         # Package manager config
├── kitty/                   # Kitty terminal
│   └── kitty.conf           # Font, colors, behavior
├── wiremix/                 # WireMix audio mixer
│   └── wiremix.toml         # Mixer config
├── zen/                     # Zen Browser
│   ├── profiles.ini         # Profile definitions (safe — no browsing data)
│   └── installs.ini         # Install tracking
└── scripts/                 # Utility scripts
    ├── update.sh            # System update utility
    ├── vsad-clean.sh        # Cache and temp file cleanup
    ├── system-info.sh       # System stats for widgets
    ├── network-info.sh      # Network status for widgets
    ├── power-menu.sh        # Power menu (fuzzel)
    ├── network-menu.sh      # Network menu (fuzzel)
    ├── backup_configs.sh    # Config backup utility
    ├── cleanup.sh           # Cleanup script
    ├── system_report.sh     # System report generator
    └── fehbg                # Wallpaper setter
```

## Dependencies

### Core
- **Compositor**: niri
- **Terminal**: kitty
- **Shell**: zsh
- **Editor**: neovim (with LazyVim)
- **File Manager**: yazi
- **Browser**: zen-browser

### Shell & Prompt
- starship
- zsh-autosuggestions
- zsh-syntax-highlighting (fast-syntax-highlighting)
- zsh-vi-mode
- zsh-history-substring-search

### CLI Tools
- fzf, fd, ripgrep (rg), eza, bat, zoxide, btop
- impala (network manager), wiremix (audio mixer)
- fuzzel (Wayland launcher), feh (wallpaper setter)

### Widgets & UI
- eww (ElKowars wacky widgets)
- waybar (alternative bar)

### Languages & Runtimes
- Rust (via rustup)
- Node.js (via nvm)

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/ArchDotFiles.git ~/ArchDotFiles

# Create symlinks to home directory
# Niri
ln -sf ~/ArchDotFiles/niri ~/.config/niri

# Neovim
ln -sf ~/ArchDotFiles/nvim ~/.config/nvim

# Zsh
ln -sf ~/ArchDotFiles/zsh/.zshrc ~/.zshrc
ln -sf ~/ArchDotFiles/zsh/.zshenv ~/.config/zsh/.zshenv
ln -sf ~/ArchDotFiles/zsh/aliases.zsh ~/.config/zsh/aliases.zsh
ln -sf ~/ArchDotFiles/zsh/bindings.zsh ~/.config/zsh/bindings.zsh
ln -sf ~/ArchDotFiles/zsh/fzf.zsh ~/.config/zsh/fzf.zsh
ln -sf ~/ArchDotFiles/zsh/plugins.zsh ~/.config/zsh/plugins.zsh
ln -sf ~/ArchDotFiles/zsh/prompt.zsh ~/.config/zsh/prompt.zsh

# Starship
ln -sf ~/ArchDotFiles/starship.toml ~/.config/starship.toml

# Yazi
ln -sf ~/ArchDotFiles/yazi ~/.config/yazi

# Kitty
ln -sf ~/ArchDotFiles/kitty/kitty.conf ~/.config/kitty/kitty.conf

# WireMix
ln -sf ~/ArchDotFiles/wiremix ~/.config/wiremix

# EWW
ln -sf ~/ArchDotFiles/eww ~/.config/eww

# Scripts
ln -sf ~/ArchDotFiles/scripts/update.sh ~/.local/bin/update.sh
ln -sf ~/ArchDotFiles/scripts/vsad-clean.sh ~/.local/bin/vsad-clean.sh
# ... (symlink other scripts as needed)
```

## Restore from Backup

```bash
# Full restore
cd ~/ArchDotFiles
./scripts/backup_configs.sh  # Backup current configs
# Then symlink as shown above
```

## Notes

- **Security**: This repository excludes SSH keys, GPG keys, browser cookies/sessions, history files, and any sensitive data.
- **Zen Browser**: Only `profiles.ini` is tracked — no browsing data, cookies, or extensions.
- **EWW**: Config sourced from backup at `~/.config/vsad/backup_20260909_204947/eww/`.

## License

Personal use.
