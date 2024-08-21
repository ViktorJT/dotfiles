#!/bin/bash

###################
# --- WELCOME --- #
###################

: '
  Install script for libraries, apps, and configs.

  Principles:

    - All libraries use their default config path
    - Homebrew is preferred (whenever possible)


  Overview:
                                                    Install   Configs
    - Homebrew (incl. xCode developer tools),         [X]       [ ]
    - Git (incl. custom configs),                     [X]       [ ]
    - Oh-My-Zsh (incl plugins),                       [X]       [X]
    - GH,                                             [X]       [ ]
    - VictorMono Nerd Font,                           [X]       [ ]
    - Starship Prompt,                                [X]       [X]
    - NVM (incl. latest Node),                        [X]       [ ]
    - NPM,                                            [X]       [ ]
    - Wezterm,                                        [X]       [X]
    - Neovim,                                         [X]       [X]
    - Ripgrep,                                        [X]       [ ]
    - FZF,                                            [X]       [ ]
    - Raycast,                                        [X]       [X]
    - Google Chrome,                                  [X]       [ ]
    - Spotify,                                        [X]       [ ]
    - System Settings (incl. keybindings)             [ ]       [X]


  To-dos:

    - Upload latest config files to GH
    - Uncomment downloading the custom configs on github
'

###################
# --- STARTUP --- #
###################



################################
# --- INSTALL DEPENDENCIES --- #
################################

# HOMEBREW
echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# OH-MY-ZSH
echo "Installing Oh-My-Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing Oh-My-Zsh plugins..."
brew install zsh-syntax-highlighting
brew install zsh-autosuggestions

# GIT
echo "Installing Git..."
brew install git

# GH
echo "Installing GH..."
brew install gh

# NERD FONT
echo "Installing VictorMono Nerd Font..."
brew install --cask font-victor-mono-nerd-font

# STARSHIP PROMPT
echo "Installing Starship..."
brew install starship

# NVM
echo "Installing NVM..."
brew install nvm

# NPM
echo "Installing NPM..."
brew install npm 

# NODE
echo "Installing latest Node..."
nvm install node

# WEZTERM
echo "Installing Wezterm..."
brew install --cask wezterm 

# NEOVIM
echo "Installing Neovim..."
brew install neovim

# RIPGREP
echo "Installing Ripgrep..."
brew install ripgrep

# FZF
echo "Installing FZF..."
brew install fzf 

# RAYCAST
echo "Installing Raycast..."
brew install --cask raycast

# GOOGLE CHROME
echo "Installing Google Chrome..."
brew install --cask google-chrome

# SPOTIFY
echo "Installing Spotify"
brew install --cask spotify


###################
# --- CONFIGS --- #
###################

echo "Downloading custom configs from GitHub..."
mkdir -p $HOME/Code/Configs
git clone https://github.com/ViktorJT/Configs.git $HOME/Code/Configs

echo "Symlinking custom ZSH config..."
ln -s $HOME/Code/Configs/.zshrc $HOME/.zshrc

echo "Symlinking custom Wezterm configs..."
ln -s $HOME/Code/Configs/wezterm $HOME/.config/wezterm

echo "Symlinking custom Neovim configs..."
ln -s $HOME/Code/Configs/nvim $HOME/.config/nvim

# HOMEBREW
echo "Adding Homebrew to PATH in ~/.zprofile..."
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# RAYCAST
echo "Starting Raycast configuration..."
open $HOME/.config/.Raycast.raycastconfig


##########################
# --- AUTHENTICATION --- #
##########################

echo "Logging into GitHub..."
gh auth login


###########################
# --- SYSTEM SETTINGS --- #
###########################

# Hide hard drive on desktop
defaults write com.apple.Finder ShowHardDrivesOnDesktop -bool false

# Show all hidden files
defaults write com.apple.finder AppleShowAllFiles -string YES

# Disable pinch to Launchpad
defaults write com.apple.dock showLaunchpadGestureEnabled -bool false 

# Add Swedish to text input sources
defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>7</integer><key>KeyboardLayout Name</key><string>Swedish</string></dict>'

# Set dark mode
defaults write -g AppleInterfaceStyle Dark

# Import custom macos key bindings (exported using commented command below)
# defaults export com.apple.symbolichotkeys - > ./macos-keyboard-shortcuts.xml
defaults import com.apple.symbolichotkeys $HOME/Code/Configs/macos-keyboard-shortcuts.xml


####################
# --- CLEANUP  --- #
####################

# Pause execution to allow external processes to finish (eg. Raycast)
read -n 1 -s -r -p "Once all processes have finished: Press any key to continue..."

# Prompt to restart the machine
echo "Some preferences might require you to restart the computer to take effect."
read -p "Do you want to restart your computer? [Y/n] " -r response

# Default to 'yes' if the user presses Enter without input
response=${response,,} # tolower
if [[ "$response" =~ ^(yes|y| ) ]] || [[ -z "$response" ]]; then
    echo "Restarting your computer..."
    sudo reboot
else
    echo "Your computer will not be restarted. Some configurations might not take effect"
fi
