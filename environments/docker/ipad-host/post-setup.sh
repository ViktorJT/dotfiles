#!/bin/bash
# iPad host Docker post-setup configuration

echo "📱 Running post-setup for iPad host environment..."

# Create projects directory if it doesn't exist
if [ ! -d "/projects" ]; then
  mkdir -p /projects
  echo "📁 Created /projects directory"
fi

# Configure tmux for better iPad experience
if [ -f "$HOME/.tmux.conf" ]; then
  # Backup existing tmux.conf
  cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup"
  
  # Add iPad-specific settings
  cat >> "$HOME/.tmux.conf" << EOF

# iPad-specific tmux settings
set -g mouse on                    # Enable mouse support
set -g history-limit 50000         # Increase scrollback buffer
set -g default-terminal "screen-256color" # Better color support
set -g status-right "#{?window_zoomed_flag,🔍 ,}#H"  # Show zoom indicator
EOF
  
  echo "🔄 Updated tmux configuration for iPad"
fi

# Configure Mosh for better iPad experience
if command -v mosh-server &> /dev/null; then
  # Ensure Mosh server starts with proper locale
  echo "export LC_ALL=en_US.UTF-8" >> "$HOME/.profile"
  echo "export LANG=en_US.UTF-8" >> "$HOME/.profile"
  
  echo "🔄 Configured Mosh for better iPad experience"
fi

# Set up development environment
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"

echo "✅ iPad host post-setup completed!"
