# Setup Scripts

This directory contains modular scripts for setting up a development environment with chezmoi across different platforms.

## Scripts Overview

- `setup.sh` - Main script that orchestrates the setup process
- `detect_environment.sh` - Detects the current environment (macOS, Linux, Docker)
- `install_dependencies.sh` - Installs core dependencies based on the environment
- `install_chezmoi.sh` - Installs chezmoi
- `setup_ssh.sh` - Sets up SSH keys for GitHub authentication
- `init_dotfiles.sh` - Initializes dotfiles with chezmoi
- `setup_environment.sh` - Sets up environment-specific configurations

## One-Line Installation

Use the following command to set up your development environment:

```bash
curl -fsSL https://raw.githubusercontent.com/ViktorJT/dotfiles/main/setup.sh | bash
```

## Modular Structure Benefits

1. **Easier to maintain** - Each script has a single responsibility
2. **Better readability** - Shorter scripts are easier to understand
3. **Reusable components** - Scripts can be used independently
4. **Easier troubleshooting** - Problems can be isolated to specific scripts

## Directory Structure

These scripts should be placed in your dotfiles repository as follows:

```
dotfiles/
├── setup.sh              # Main entry point script
├── scripts/              # Directory for modular scripts
│   ├── detect_environment.sh
│   ├── install_dependencies.sh
│   ├── install_chezmoi.sh
│   ├── setup_ssh.sh
│   ├── init_dotfiles.sh
│   └── setup_environment.sh
├── home/                 # Dotfiles managed by chezmoi
│   └── ...
└── docker/               # Docker-related files
    ├── Dockerfile
    └── docker-compose.yml
```

## Development

To modify or add new functionality:

1. Edit the specific script that handles that functionality
2. If adding a new script, update `setup.sh` to include it
3. Test changes in different environments
4. Commit and push changes to your repository
