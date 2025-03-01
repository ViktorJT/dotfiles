#!/bin/bash

###################
# --- WELCOME --- #
###################

: '
  Setup script to install Chezmoi and set up SSH Keys for Github
  
  ┌–– Overview –––––––––––––––––––––––––––––––––┐
  │                                             │
  │   - Install ChezMoi				│
  │   - Setup SSH key				│
  │   - Init dotfiles				│
  │						│
  └–––––––––––––––––––––––––––––––––––––––––––––┘
'


###################################
# --- STEP 1: Install ChezMoi --- #
###################################

echo "📦 Installing ChezMoi..."
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install chezmoi
else
  sh -c "$(wget -qO- get.chezmoi.io)" -- -b $HOME/.local/bin
fi


#################################
# --- STEP 2: Setup SSH key --- #
#################################

if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
  echo "🔑 No SSH key found. Let's generate one!"

  # Loop until a valid name is entered
  while true; do
    echo -n "Enter a name for this SSH key (e.g., 'Macbook-Pro'): "
    read ssh_key_label

    # Check if input is empty
    if [[ -z "$ssh_key_label" ]]; then
      echo "❌ Error: SSH key name cannot be empty. Please enter a valid name."
      continue
    fi

    # Check if input contains only valid characters (letters, numbers, dashes, underscores)
    if [[ ! "$ssh_key_label" =~ ^[a-zA-Z0-9_-]+$ ]]; then
      echo "❌ Error: SSH key name can only contain letters, numbers, dashes (-), and underscores (_)."
      continue
    fi

    # If input is valid, break out of the loop
    break
  done

  # Generate SSH key with the validated label
  ssh-keygen -t ed25519 -C "$ssh_key_label" -f "$HOME/.ssh/id_ed25519" -N ""

  # Fix permissions
  chmod 600 "$HOME/.ssh/id_ed25519"

  echo "✅ SSH key successfully created!"

  echo "🔓 Your public key:"
  cat "$HOME/.ssh/id_ed25519.pub"

  # Copy SSH key to clipboard (macOS, Linux)
  if [[ "$OSTYPE" == "darwin"* ]]; then
    pbcopy < "$HOME/.ssh/id_ed25519.pub"
    echo "📋 SSH key copied to clipboard!"
  elif command -v xclip &> /dev/null; then
    xclip -selection clipboard < "$HOME/.ssh/id_ed25519.pub"
    echo "📋 SSH key copied to clipboard!"
  elif command -v wl-copy &> /dev/null; then
    wl-copy < "$HOME/.ssh/id_ed25519.pub"
    echo "📋 SSH key copied to clipboard!"
  else
    echo "⚠️ Clipboard copy not supported on this system. Manually copy the key above."
  fi

  # Clickable GitHub link (supported in most terminals)
  echo -e "📌 Add your SSH key to GitHub: \033]8;;https://github.com/settings/keys\ahttps://github.com/settings/keys\033]8;;\a"
  read -p "Press Enter once you've added the SSH key to GitHub..."
else
  echo "✅ SSH key already exists, skipping..."
fi

echo "🔍 Testing SSH connection to GitHub..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  echo "✅ SSH authentication successful!"
else
  echo "❌ SSH authentication failed. Make sure you added your key to GitHub!"
  exit 1
fi


#################################
# --- STEP 3: Init dotfiles --- #
#################################

default_repo="git@github.com:ViktorJT/dotfiles.git"
read -p "Enter your dotfiles repository URL (Press Enter for default: $default_repo): " dotfiles_repo
dotfiles_repo=${dotfiles_repo:-$default_repo}  # Use input if provided, otherwise use default

echo "⚙ Initializing ChezMoi..."
chezmoi init "$dotfiles_repo" --ssh

echo "🎨 Applying dotfiles..."
chezmoi apply

echo "✅ ChezMoi setup complete!"
