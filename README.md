# Dotfiles

Modern, modular dotfiles repository managed with chezmoi.

## Structure

- `machine/` - Configuration for your physical machine
  - `.chezmoiscripts/` - Machine-specific scripts
  - `home/` - Files that map to $HOME
- `.chezmoitemplates/` - Shared templates
  - `defaults/` - Base configurations for all environments
  - `shared/` - Shared configurations for categories of environments
  - `macos/` - macOS-specific configurations
  - `linux/` - Linux-specific configurations
- `containers/` - Docker container configurations
  - `web-dev/` - Web development environment
  - `data-science/` - Data science environment

## Installation

### Machine Environment

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --source=https://github.com/ViktorJT/dotfiles.git/machine --apply
```

### Docker Environments

```bash
# Web Development Environment
curl -fsSL https://raw.githubusercontent.com/ViktorJT/dotfiles/main/scripts/setup-container.sh | bash -s -- web-dev

# Data Science Environment
curl -fsSL https://raw.githubusercontent.com/ViktorJT/dotfiles/main/scripts/setup-container.sh | bash -s -- data-science
```

## Features

- Completely separate configurations for physical machine and Docker containers
- Modular structure with defaults, shared, and environment-specific configurations
- Automatic environment detection and configuration
- Support for multiple Docker environments
