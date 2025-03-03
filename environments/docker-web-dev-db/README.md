# Docker Development Environment for Synology NAS

This development environment is designed to run on a Synology NAS and be accessed via Mosh from an iPad Pro using Blink Shell.

## Features

- Ubuntu 22.04 base with development tools
- Zsh with Oh My Zsh
- Neovim
- Tmux
- Mosh for stable iPad connections
- NVM for Node.js management
- Starship prompt
- Chezmoi for dotfile management

## Setup Instructions

### 1. Prepare Your Environment

1. Upload the Dockerfile, docker-compose.yml, and setup.sh to your Synology NAS
2. Ensure Docker is installed on your Synology NAS

### 2. Build and Start the Container

```bash
# Navigate to the directory with your files
cd /volume1/docker/dev-env-setup

# Build and start the container
docker-compose up -d

# Enter the container
docker exec -it dev-env zsh
```

### 3. Run the Setup Script

Once inside the container, run:

```bash
/root/setup.sh
```

This will:
- Generate SSH keys (if needed)
- Help you configure GitHub access
- Initialize chezmoi with your dotfiles repository
- Apply your configurations

### 4. Connect from iPad Pro + Blink Shell

In Blink Shell:

1. Add a new host:
   - Host: Your Synology NAS IP
   - Port: 22 (SSH) or 60000-60010 (Mosh)
   - User: root

2. Connect using Mosh for a stable connection:
   ```
   mosh --port=60001 root@your-synology-ip
   ```

## Using Chezmoi

### Add New Dotfiles

```bash
# Add a file to be managed
chezmoi add ~/.config/some-config-file

# Edit a managed file
chezmoi edit ~/.config/some-config-file

# Apply changes
chezmoi apply
```

### Update From Your Repository

```bash
chezmoi update
```

### Create/Edit Template Files

Templates allow different settings based on the host machine:

```bash
chezmoi edit ~/.config/some-config.tmpl
```

Example template syntax:
```
{{- if .data.docker -}}
# Docker-specific settings
{{- else -}}
# Non-Docker settings
{{- end -}}
```

## Persistent Storage

Your development environment uses persistent storage at `/volume1/docker/dev-env` on your Synology NAS. This ensures:

- Your dotfiles remain between container restarts
- SSH keys are preserved
- Work in progress is saved

## Troubleshooting

### SSH Connection Issues

If you're having trouble connecting to GitHub:

```bash
ssh -vT git@github.com
```

### Container Access Issues

If you can't access the container:

```bash
# Check if container is running
docker ps | grep dev-env

# Check container logs
docker logs dev-env
```

### Mosh Connection Issues

If Mosh isn't connecting:

1. Ensure ports 60000-60010/UDP are open on your Synology firewall
2. Try specifying a specific port: `mosh --port=60001 root@your-synology-ip`
