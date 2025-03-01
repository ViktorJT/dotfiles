#!/bin/bash

# Script to set up environment-specific configurations

setup_environment_specific() {
  echo "🛠️ Setting up environment-specific configurations..."
  
  # Prompt for user information with defaults
  DEFAULT_NAME="Viktor"
  DEFAULT_EMAIL="v.jensentorp@gmail.com"
  
  read -p "Enter your name for Git config [default: $DEFAULT_NAME]: " USER_NAME
  USER_NAME=${USER_NAME:-$DEFAULT_NAME}
  
  read -p "Enter your email for Git config [default: $DEFAULT_EMAIL]: " USER_EMAIL
  USER_EMAIL=${USER_EMAIL:-$DEFAULT_EMAIL}
  
  # Update git config
  git config --global user.name "$USER_NAME"
  git config --global user.email "$USER_EMAIL"
  echo "✅ Git configuration updated!"
  
  # Create or update chezmoi config with environment information
  cat > "$HOME/.chezmoi.toml.tmpl" << EOF
# ~/.chezmoi.toml.tmpl
{{- \$isDocker := false -}}
{{- \$dockerType := "" -}}
{{- \$isMacOS := false -}}
{{- \$isLinux := false -}}

{{- if eq .chezmoi.os "darwin" -}}
{{-   \$isMacOS = true -}}
{{- else if eq .chezmoi.os "linux" -}}
{{-   \$isLinux = true -}}
{{-   if (.chezmoi.kernel.osrelease | lower | contains "docker") -}}
{{-     \$isDocker = true -}}
{{-     /* Try to detect Docker container type */ -}}
{{-     if (.chezmoi.hostname | lower | contains "web") -}}
{{-       \$dockerType = "web" -}}
{{-     else if (.chezmoi.hostname | lower | contains "data") -}}
{{-       \$dockerType = "data-science" -}}
{{-     else if (.chezmoi.hostname | lower | contains "dev") -}}
{{-       \$dockerType = "ipad-host" -}}
{{-     else -}}
{{-       \$dockerType = "dev" -}}
{{-     end -}}
{{-   end -}}
{{- end -}}

[data]
    docker = {{ \$isDocker }}
    dockerType = "{{ \$dockerType }}"
    macos = {{ \$isMacOS }}
    linux = {{ \$isLinux }}
    hostname = "{{ .chezmoi.hostname }}"
    username = "{{ .chezmoi.username }}"
    email = "$USER_EMAIL"
    name = "$USER_NAME"
EOF
  
  echo "✅ Environment configuration set up!"
}
