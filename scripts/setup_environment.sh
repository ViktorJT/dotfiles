#!/bin/bash

# Script to set up environment-specific configurations

setup_environment_specific() {
  echo "🛠️ Setting up environment-specific configurations..."
  
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
    email = "youremail@example.com"  # Replace with your email
    name = "Your Name"  # Replace with your name
EOF
  
  echo "✅ Environment configuration set up!"
}
