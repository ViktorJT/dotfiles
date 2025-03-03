#!/bin/bash
set -e  # Exit immediately if any command fails

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ Embedded Logging Module                                                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Terminal colors
if [[ -t 1 ]]; then
  RESET="\033[0m"
  BOLD="\033[1m"
  RED="\033[31m"
  GREEN="\033[32m"
  YELLOW="\033[33m"
  BLUE="\033[34m"
  MAGENTA="\033[35m"
  CYAN="\033[36m"
else
  RESET=""
  BOLD=""
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  MAGENTA=""
  CYAN=""
fi

# Get terminal width (default to 80 if unable to determine)
TERM_WIDTH=$(tput cols 2>/dev/null || echo 80)
BOX_WIDTH=$((TERM_WIDTH - 2))  # Allow for borders

# Fancy logging functions
log_header() {
  echo ""
  echo "┏${CYAN}$(printf '━%.0s' $(seq 1 $BOX_WIDTH))${RESET}┓"
  echo "┃${BOLD}$(printf " %-${BOX_WIDTH}s " "🚀 $1")${RESET}┃"
  echo "┗${CYAN}$(printf '━%.0s' $(seq 1 $BOX_WIDTH))${RESET}┛"
  echo ""
}

log_section() {
  echo ""
  echo "┏${BLUE}$(printf '━%.0s' $(seq 1 $BOX_WIDTH))${RESET}┓"
  echo "┃${BOLD}$(printf " %-${BOX_WIDTH}s " "📌 $1")${RESET}┃"
  echo "┗${BLUE}$(printf '━%.0s' $(seq 1 $BOX_WIDTH))${RESET}┛"
  echo ""
}

log_step() {
  printf " ${CYAN}▶${RESET} %s\n" "$1"
}

log_success() {
  printf " ${GREEN}✓${RESET} %s\n" "$1"
}

log_warning() {
  printf " ${YELLOW}⚠${RESET} %s\n" "$1"
}

log_error() {
  printf " ${RED}✗${RESET} %s\n" "$1"
}

log_info() {
  printf " ${BLUE}ℹ${RESET} %s\n" "$1"
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
  echo " ┏${GREEN}$(printf '━%.0s' $(seq 1 $((BOX_WIDTH - 2))))${RESET}┓"
  echo " ┃$(printf " %-$((BOX_WIDTH - 4))s " "🎉 $1")┃"
  echo " ┗${GREEN}$(printf '━%.0s' $(seq 1 $((BOX_WIDTH - 2))))${RESET}┛"
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