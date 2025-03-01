# Dotfiles

A modular, cross-platform dotfiles repository managed with [chezmoi](https://www.chezmoi.io/).

## Features

- 🌈 Works across multiple environments (macOS, Linux, Docker)
- 🧩 Modular structure for easy maintenance
- 🚀 One-line setup script for quick deployment
- 🔒 SSH key management for GitHub
- 🔄 Automatic updates for dependencies
- 🎨 Environment-specific configurations

## Quick Setup

```bash
# macOS Setup
curl -s https://gist.githubusercontent.com/ViktorJT/d1d7d488057827ab16af656ce828b166/raw/macbook-install.sh | bash

# iPad Host (Synology Docker) Setup
curl -s https://gist.githubusercontent.com/ViktorJT/0beed64647d907bf721225fcd0d8c201/raw/ipad-host-install.sh | bash
```

## Repository Structure

```
dotfiles/
├── .chezmoiexternal.toml    # External dependencies
├── .chezmoiignore           # Files to ignore during apply
├── .chezmoiroot             # Specifies source directory
├── setup.sh                 # Main setup script
├── home/                    # Dotfiles managed by chezmoi
│   ├── run_once_install-packages.sh.tmpl  # Environment setup script
│   ├── dot_zshrc.tmpl       # ZSH configuration (templated)
│   ├── nvim/                # Neovim configuration (NvChad)
│   ├── wezterm/             # WezTerm terminal configuration
│   └── starship.toml        # Starship prompt configuration
├── environments/            # Environment-specific configurations
│   ├── docker/              # Docker environment
│   │   ├── common/          # Common Docker settings
│   │   │   ├── base-dependencies.sh  # Common dependencies
│   │   │   ├── zsh.plugins           # ZSH plugins
│   │   │   ├── zsh.configuration     # ZSH configuration
│   │   │   ├── zsh.functions         # ZSH functions
│   │   │   └── zsh.aliases           # ZSH aliases
│   │   └── ipad-host/       # iPad-specific Docker setup
│   │       ├── Dockerfile            # Container definition
│   │       ├── docker-compose.yml    # Container orchestration
│   │       ├── dependencies.sh       # iPad-specific dependencies
│   │       ├── post-setup.sh         # Post-installation tasks
│   │       ├── zsh.plugins           # ZSH plugins
│   │       ├── zsh.configuration     # ZSH configuration
│   │       ├── zsh.functions         # ZSH functions
│   │       └── zsh.aliases           # ZSH aliases
│   └── macos/                # macOS environment
│       ├── dependencies.sh          # macOS dependencies
│       ├── defaults.sh              # macOS system defaults
│       ├── macos-keyboard-shortcuts.xml  # Keyboard shortcuts
│       ├── Raycast.rayconfig        # Raycast configuration
│       ├── zsh.plugins              # ZSH plugins
│       ├── zsh.configuration        # ZSH configuration
│       ├── zsh.functions            # ZSH functions
│       └── zsh.aliases              # ZSH aliases
└── scripts/                  # Setup scripts
    ├── detect_environment.sh       # Environment detection
    ├── install_dependencies.sh     # Core dependencies
    ├── install_chezmoi.sh          # Chezmoi installation
    ├── setup_ssh.sh                # SSH key setup
    ├── init_dotfiles.sh            # Dotfiles initialization
    └── setup_environment.sh        # Environment configuration
```

## Modular ZSH Configuration

The ZSH configuration is modular and adapts to different environments:

- Base configuration in `dot_zshrc.tmpl`
- Environment-specific plugins in `environments/<env>/zsh.plugins`
- Environment-specific configurations in `environments/<env>/zsh.configuration`
- Environment-specific functions in `environments/<env>/zsh.functions`
- Environment-specific aliases in `environments/<env>/zsh.aliases`

This approach allows specialized configurations for each environmnt while maintaining a single dotfiles repository.

## Neovim Configuration

This repository includes a comprehensive Neovim setup based on NvChad:

- Lazy.nvim for plugin management
- LSP support with Mason for installing language servers
- Syntax highlighting with TreeSitter
- Formatting and linting with Conform.nvim and nvim-lint
- A clean, modern UI with Nord theme

## Adding New Environments

To add a new environment:

1. Create a new directory in `environments/`
2. Add environment-specific files (dependencies, configurations)
3. Update templates to handle the new environment

## Updating Configuration Files

To edit any configuration files:

```bash
# Edit ZSH configuration
chezmoi edit ~/.zshrc

# Edit Neovim configuration
chezmoi edit ~/.config/nvim/init.lua

# Apply changes
chezmoi apply

# Push changes to repository
chezmoi cd
git add .
git commit -m "Update configurations"
git push
```

## Exporting macOS Settings

```bash
# Export keyboard shortcuts
defaults export com.apple.symbolichotkeys - > ~/dotfiles/environments/macos/macos-keyboard-shortcuts.xml

# Export Raycast preferences
# Raycast Settings > Advanced > Import / Export > Export
# Move the exported file to ~/dotfiles/environments/macos/Raycast.rayconfig
```

## Maintaining Your Dotfiles

```bash
# Update dotfiles from repository
chezmoi update

# Add a new file to be managed
chezmoi add ~/.config/new-config-file

# Remove a file from management
chezmoi forget ~/.config/old-config-file
```e
