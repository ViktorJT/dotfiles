#!/bin/bash
set -e  # Exit immediately if any command fails

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ Embedded Logging Module                                                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Get terminal width (default to 80 if unable to determine)
TERM_WIDTH=80
if command -v tput &>/dev/null && tty -s; then
  TERM_WIDTH=$(tput cols 2>/dev/null || echo 80)
fi
BOX_WIDTH=$((TERM_WIDTH - 2))  # Allow for borders

# Fancy logging functions - no colors, just ASCII art
log_header() {
  echo ""
  echo "┏━$(printf '━%.0s' $(seq 1 $((BOX_WIDTH - 2))))━┓"
  echo "┃ $(printf "%-${BOX_WIDTH}s" "🚀 $1") ┃"
  echo "┗━$(printf '━%.0s' $(seq 1 $((BOX_WIDTH - 2))))━┛"
  echo ""
}

log_section() {
  echo ""
  echo "┏━$(printf '━%.0s' $(seq 1 $((BOX_WIDTH - 2))))━┓"
  echo "┃ $(printf "%-${BOX_WIDTH}s" "📌 $1") ┃"
  echo "┗━$(printf '━%.0s' $(seq 1 $((BOX_WIDTH - 2))))━┛"
  echo ""
}

log_step() {
  printf " ▶ %s\n" "$1"
}

log_success() {
  printf " ✓ %s\n" "$1"
}

log_warning() {
  printf " ⚠ %s\n" "$1"
}

log_error() {
  printf " ✗ %s\n" "$1"
}

log_info() {
  printf " ℹ %s\n" "$1"
}

log_command_output() {
  echo " ┌$(printf '─%.0s' $(seq 1 $((BOX_WIDTH - 2))))┐"
  while IFS= read -r line; do
    printf " │ %-$((BOX_WIDTH - 4))s │\n" "$line"
  done
  echo " └$(printf '─%.0s' $(seq 1 $((BOX_WIDTH - 2))))┘"
}

log_code_block() {
  echo " ┌$(printf '─%.0s' $(seq 1 $((BOX_WIDTH - 2))))┐"
  echo "$1" | while IFS= read -r line; do
    printf " │ %-$((BOX_WIDTH - 4))s │\n" "$line"
  done
  echo " └$(printf '─%.0s' $(seq 1 $((BOX_WIDTH - 2))))┘"
}

log_success_block() {
  echo ""
  echo " ┏━$(printf '━%.0s' $(seq 1 $((BOX_WIDTH - 4))))━┓"
  echo " ┃ $(printf "%-$((BOX_WIDTH - 4))s" "🎉 $1") ┃"
  echo " ┗━$(printf '━%.0s' $(seq 1 $((BOX_WIDTH - 4))))━┛"
  echo ""
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ Main Script                                                                  ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

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

# Test the logging functions
log_header "Setting up your development environment"
log_section "Logging Test"
log_step "This is a step"
log_info "This is information"
log_success "This is success"
log_warning "This is a warning"
log_error "This is an error"

# Test command output formatting
echo "Line 1 of command output
Line 2 of command output
Line 3 with a longer text that might wrap depending on your terminal width" | log_command_output

# Test code block
log_code_block "function example() {
  return 'This is a code block example';
}"

log_success_block "Your development environment is ready!"

echo "Basic setup script test complete!"