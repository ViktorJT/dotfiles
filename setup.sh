#!/bin/bash
set -e  # Exit immediately if any command fails

# Default configuration
ENV_TYPE=""       # Environment type (e.g., "macos", "docker-ipad")
SSH_KEY_NAME=""   # Custom SSH key name
UPDATE_DOTFILES=true

# Parse command line arguments
for arg in "$@"; do
  case $arg in
    --env=*)
      ENV_TYPE="${arg#*=}"
      ;;
    --ssh-key=*)
      SSH_KEY_NAME="${arg#*=}"
      ;;
    --update-dotfiles=*)
      UPDATE_DOTFILES="${arg#*=}"
      ;;
    *)
      # Legacy support: first arg as SSH key name
      if [[ -z "$SSH_KEY_NAME" ]]; then
        SSH_KEY_NAME="$arg"
      fi
      ;;
  esac
done

# Set up temporary directory for downloaded scripts
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Download and source the logging functions
download_logging_utils() {
  LOGGING_SCRIPT="$TEMP_DIR/logging.sh"
  curl -fsSL "https://raw.githubusercontent.com/ViktorJT/dotfiles/main/scripts/utils/logging.sh" -o "$LOGGING_SCRIPT"
  if [ -f "$LOGGING_SCRIPT" ]; then
    source "$LOGGING_SCRIPT"
  else
    # Fallback minimal logging if download fails
    log_header() { echo "=== $1 ==="; }
    log_section() { echo "--- $1 ---"; }
    log_step() { echo "-> $1"; }
    log_success() { echo "✓ $1"; }
    log_warning() { echo "! $1"; }
    log_error() { echo "✗ $1"; }
    log_info() { echo "i $1"; }
    log_command_output() { cat; }
    log_code_block() { echo "$1"; }
    log_success_block() { echo "🎉 $1"; }
  fi
}

# Install minimal dependencies
install_deps() {
  log_section "Checking for required dependencies"
  
  # Check for git
  if ! command -v git &>/dev/null; then
    log_step "Git not found. Installing..."
    if command -v apt &>/dev/null; then
      sudo apt update && sudo apt install -y git
    elif command -v brew &>/dev/null; then
      brew install git
    elif command -v pacman &>/dev/null; then
      sudo pacman -Sy --noconfirm git
    elif command -v dnf &>/dev/null; then
      sudo dnf install -y git
    else
      log_error "Unable to install git. Please install it manually."
      exit 1
    fi
    log_success "Git installed successfully."
  else
    log_success "Git already installed."
  fi
}

# Install chezmoi if needed
install_chezmoi() {
  log_section "Setting up chezmoi"
  
  if ! command -v chezmoi &>/dev/null; then
    log_step "Installing chezmoi..."
    
    # Run the installer and capture output
    INSTALL_OUTPUT=$(sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" 2>&1)
    echo "$INSTALL_OUTPUT" | log_command_output
    
    # Add chezmoi to PATH for this session
    export PATH="$HOME/.local/bin:$PATH"
    
    if ! command -v chezmoi &>/dev/null; then
      log_error "Failed to install chezmoi. Please install it manually."
      exit 1
    fi
    
    log_success "Chezmoi installed successfully!"
  else
    log_success "Chezmoi already installed."
  fi
  
  # Display chezmoi version
  CHEZMOI_VERSION=$(chezmoi --version)
  log_info "Using chezmoi version: $CHEZMOI_VERSION"
}

# Generate SSH key if requested
generate_ssh_key() {
  log_section "SSH Key Setup"
  
  if [[ -z "$SSH_KEY_NAME" ]]; then
    SSH_KEY_NAME="$(hostname)-$(date +%Y%m%d)"
  fi
  
  if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
    log_step "Generating new SSH key: $SSH_KEY_NAME"
    
    # Ensure .ssh directory exists with proper permissions
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    
    # Generate the key
    ssh-keygen -t ed25519 -C "$SSH_KEY_NAME" -f "$HOME/.ssh/id_ed25519" -N ""
    chmod 600 "$HOME/.ssh/id_ed25519"
    
    log_success "SSH key generated!"
    
    # Display the public key
    echo ""
    log_info "Your SSH public key (add this to GitHub):"
    SSH_KEY=$(cat "$HOME/.ssh/id_ed25519.pub")
    log_code_block "$SSH_KEY"
  else
    log_success "SSH key already exists at ~/.ssh/id_ed25519"
  fi
}

main() {
  # First download and source the logging utility
  download_logging_utils
  
  log_header "Setting up your development environment"
  
  # Show configuration
  log_section "Configuration"
  log_info "Environment:       ${ENV_TYPE:-"Auto-detect"}"
  log_info "SSH Key Name:      ${SSH_KEY_NAME:-"Auto-generate"}"
  log_info "Update Dotfiles:   $UPDATE_DOTFILES"
  
  # Install dependencies
  install_deps
  install_chezmoi

  # Prepare extra args for chezmoi init
  EXTRA_ARGS=""
  if [[ ! -z "$ENV_TYPE" ]]; then
    EXTRA_ARGS="$EXTRA_ARGS --data=environment=$ENV_TYPE"
  fi
  if [[ ! -z "$SSH_KEY_NAME" ]]; then
    EXTRA_ARGS="$EXTRA_ARGS --data=ssh.keyName=$SSH_KEY_NAME"
  fi
  EXTRA_ARGS="$EXTRA_ARGS --data=update=$UPDATE_DOTFILES"

  # Initialize and apply chezmoi
  log_section "Initializing Dotfiles"
  
  if [ -d "$HOME/.local/share/chezmoi" ]; then
    if [ "$UPDATE_DOTFILES" = true ]; then
      log_step "Updating existing dotfiles..."
      chezmoi update $EXTRA_ARGS
    else
      log_warning "Skipping update as requested"
    fi
  else
    log_step "First-time setup, initializing dotfiles repository..."
    # Use HTTPS for initial setup
    chezmoi init https://github.com/ViktorJT/dotfiles.git $EXTRA_ARGS
    
    log_step "Applying dotfiles configuration..."
    chezmoi apply
  fi
  
  # Generate SSH key after everything else
  generate_ssh_key
  
  log_header "Setup Complete!"
  
  # Show next steps
  log_section "Next Steps"
  log_info "1. Add your SSH key to GitHub: https://github.com/settings/keys"
  log_info "2. Test your connection: ssh -T git@github.com"
  log_info "3. (Optional) Switch to SSH remote: chezmoi git remote set-url origin git@github.com:ViktorJT/dotfiles.git"
  
  log_success_block "Your development environment is ready! Enjoy!"
}

main "$@"