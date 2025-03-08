#!/bin/bash
# scripts/setup-container.sh
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <container-name> [additional-args]"
    echo "Available containers:"
    ls -1 "$DOTFILES_DIR/containers" | grep -v "_common"
    exit 1
fi

CONTAINER_NAME="$1"
shift

CONTAINER_DIR="$DOTFILES_DIR/containers/$CONTAINER_NAME"
if [ ! -d "$CONTAINER_DIR" ]; then
    echo "Container not found: $CONTAINER_NAME"
    exit 1
fi

echo "Setting up Docker container: $CONTAINER_NAME"

# Create Docker working directory
DOCKER_DIR="$HOME/docker/$CONTAINER_NAME"
mkdir -p "$DOCKER_DIR"

# Initialize chezmoi for this container
chezmoi init --source="$CONTAINER_DIR" --apply=false

# Generate Docker files
echo "Generating Docker files..."
chezmoi execute-template --source="$CONTAINER_DIR" < "$CONTAINER_DIR/Dockerfile.tmpl" > "$DOCKER_DIR/Dockerfile"
chezmoi execute-template --source="$CONTAINER_DIR" < "$CONTAINER_DIR/docker-compose.yml.tmpl" > "$DOCKER_DIR/docker-compose.yml"

echo "Docker container prepared in $DOCKER_DIR"
echo "To build and run: cd $DOCKER_DIR && docker-compose up -d"
