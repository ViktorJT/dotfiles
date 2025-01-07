export PATH=$PATH:/bin:/usr/bin:/usr/local/bin

# Path to Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="nord-extended/nord"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# Plugins sourced separately below don't need to be added
plugins=()

source $ZSH/oh-my-zsh.sh

# Setting language environment
export LANG=en_US.UTF-8

# Enable FzF
source <(fzf --zsh)

# Enable NVM
export NVM_DIR="$HOME/.nvm"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# Enable Starship Prompt
eval "$(starship init zsh)"

# Enable ZSH Autosuggestions plugin
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable ZSH Syntax Highlighting plugin (should load last)
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Custom scripts

pbcopy_files() {
  setopt nullglob  # Allow wildcards with no matches

  local save_to_folder=false
  local output_folder="pbcopy_files_output"
  local target_path=""
  local processed_count=0
  local root_folder=$(basename $(pwd))
  export PATH=$PATH:/bin:/usr/bin:/usr/local/bin

  # Parse command line options
  while getopts ":s" opt; do
    case ${opt} in
      s ) save_to_folder=true ;;
      \? ) echo "\033[1;31mError: Invalid option: -$OPTARG\033[0m" >&2; return 1 ;;
    esac
  done
  shift $((OPTIND -1))

  # Check if a target path is provided
  if [ $# -eq 0 ]; then
    echo "\033[1;31mError: No target path provided.\033[0m"
    echo "Usage: pbcopy_files [-s] /path/to/file_or_folder"
    return 1
  fi

  target_path="$1"
  local base_path=$(pwd)  # Get the current working directory (root path)

  # Function to determine the correct comment style based on file extension
  get_comment_style() {
    local filename="$1"
    case "$filename" in
      *.js|*.jsx|*.ts|*.tsx|*.mjs|*.cjs) echo "//" ;;
      *.css|*.html) echo "/* */" ;;
      *.lua) echo "--" ;;
      *.py|*.rb|*.sh|*.zsh|*.bash|*.ksh) echo "#" ;;
      *.c|*.cpp|*.h|*.hpp|*.java|*.go|*.swift) echo "//" ;;
      *) echo "/* */" ;;
    esac
  }

  # Function to sanitize file path for use as a filename
  sanitize_path() {
    echo "$1" | sed "s|^\.\/||" | sed "s|\/|>|g"
  }

  # Process an individual file
  process_file() {
    local file="$1"
    local comment_style=$(get_comment_style "$file")
    local relative_path="${file#$base_path/}"

    # Determine if it's a block comment style (like /* ... */)
    if [[ "$comment_style" == "/* */" ]]; then
      local content="/* Current file: $relative_path */\n$(cat "$file")"
    else
      local content="$comment_style Current file: $relative_path\n$(cat "$file")"
    fi

    if $save_to_folder; then
      local sanitized_path="${root_folder}>$(sanitize_path "$relative_path")"
      echo "$content" > "$output_folder/$sanitized_path"
    else
      echo "$content" | pbcopy
    fi

    ((processed_count++))
  }

  # Process a folder recursively
  process_files() {
    local dir="$1"

    for file in "$dir"/*; do
      if [ -f "$file" ]; then
        local relative_path="${file#$base_path/}"
        echo -n "Process $relative_path? (Enter/s/q): "
        read -k 1 user_input
        echo
        case $user_input in
          s|S) echo "Skipped." ;;
          q|Q) echo "Quitting..."; return ;;
          *) process_file "$file" ;;
        esac
      elif [ -d "$file" ]; then
        process_files "$file"
      fi
    done
  }

  # Create or clear output folder if saving to folder
  if $save_to_folder; then
    if [ -d "$output_folder" ]; then
      echo "Removing existing output folder..."
      rm -rf "$output_folder"
    fi
    mkdir -p "$output_folder"
    echo "Created fresh output folder: $output_folder"
  fi

  # Process the target path
  if [ -f "$target_path" ]; then
    process_file "$target_path"
  elif [ -d "$target_path" ]; then
    process_files "$target_path"
  else
    echo "\033[1;31mError: $target_path is not a valid file or folder.\033[0m"
    echo "Usage: pbcopy_files [-s] /path/to/file_or_folder"
    return 1
  fi

  # Print summary
  if $save_to_folder; then
    echo "Saved $processed_count file(s) to $output_folder/"
  else
    echo "Copied $processed_count file(s) to clipboard."
  fi
}

# Custom scripts

pbcopy_files() {
  setopt nullglob  # Allow wildcards with no matches

  local save_to_folder=false
  local output_folder="pbcopy_files_output"
  local target_path=""
  local processed_count=0
  local root_folder=$(basename "$(pwd)")
  export PATH=$PATH:/bin:/usr/bin:/usr/local/bin

  # Parse command line options
  while getopts ":s" opt; do
    case ${opt} in
      s ) save_to_folder=true ;;
      \? ) echo "\033[1;31mError: Invalid option: -$OPTARG\033[0m" >&2; return 1 ;;
    esac
  done
  shift $((OPTIND -1))

  # Check if a target path is provided
  if [ $# -eq 0 ]; then
    echo "\033[1;31mError: No target path provided.\033[0m"
    echo "Usage: pbcopy_files [-s] /path/to/file_or_folder"
    return 1
  fi

  target_path="$1"
  local base_path=$(pwd)  # Get the current working directory (root path)

  # Function to determine the correct comment style based on file extension
  get_comment_style() {
    local filename="$1"
    case "$filename" in
      *.js|*.jsx|*.ts|*.tsx|*.mjs|*.cjs) echo "//" ;;
      *.css|*.html) echo "/* */" ;;
      *.lua) echo "--" ;;
      *.py|*.rb|*.sh|*.zsh|*.bash|*.ksh) echo "#" ;;
      *.c|*.cpp|*.h|*.hpp|*.java|*.go|*.swift) echo "//" ;;
      *) echo "/* */" ;;
    esac
  }

  # Function to sanitize file path for use as a filename
  sanitize_path() {
    echo "$1" | sed "s|^\./||" | sed "s|/|>|g"
  }

  # Process an individual file
  process_file() {
    local file="$1"
    local comment_style=$(get_comment_style "$file")
    local relative_path="${file#$base_path/}"

    # Determine if it's a block comment style (like /* ... */)
    if [[ "$comment_style" == "/* */" ]]; then
      local content="/* Current file: $relative_path */\n$(cat "$file")"
    else
      local content="$comment_style Current file: $relative_path\n$(cat "$file")"
    fi

    if $save_to_folder; then
      local sanitized_path="${root_folder}>$(sanitize_path "$relative_path")"
      echo -e "$content" > "$output_folder/$sanitized_path"
    else
      echo -e "$content" | pbcopy
    fi

    ((processed_count++))
  }

  # Process a folder recursively
  process_files() {
    local dir="$1"

    for file in "$dir"/*; do
      if [ -f "$file" ]; then
        local relative_path="${file#$base_path/}"
        echo -n "Process $relative_path? (Enter/s/q): "
        read -k 1 user_input
        echo
        case $user_input in
          s|S) echo "Skipped." ;;
          q|Q) echo "Quitting..."; return ;;
          *) process_file "$file" ;;
        esac
      elif [ -d "$file" ]; then
        process_files "$file"
      fi
    done
  }

  # Create or clear output folder if saving to folder
  if $save_to_folder; then
    if [ -d "$output_folder" ]; then
      echo "Removing existing output folder..."
      rm -rf "$output_folder"
    fi
    mkdir -p "$output_folder"
    echo "Created fresh output folder: $output_folder"
  fi

  # Process the target path
  if [ -f "$target_path" ]; then
    process_file "$target_path"
  elif [ -d "$target_path" ]; then
    process_files "$target_path"
  else
    echo "\033[1;31mError: $target_path is not a valid file or folder.\033[0m"
    echo "Usage: pbcopy_files [-s] /path/to/file_or_folder"
    return 1
  fi

  # Print summary
  if $save_to_folder; then
    echo "Saved $processed_count file(s) to $output_folder/"
  else
    echo "Copied $processed_count file(s) to clipboard."
  fi
}
