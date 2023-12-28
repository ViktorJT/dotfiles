#!/bin/bash

sudo apt update

# Check if Zsh is installed
if [ -f /bin/zsh ] || [ -f /usr/bin/zsh ]; then
    echo "Zsh already installed"
else
    echo "Installing Zsh"
    sudo apt install zsh -y
    exit 1
fi

# Install pyenv

# MacOS
# brew install pyenv

# Ubuntu 
# curl https://pyenv.run | bash

# Install latest python 3 version
# pyenv install 3:latest

# Set zsh as default shell
sudo chsh -s $(which zsh) $(whoami)

# Install oh-my-zsh
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install starship prompt
sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)"

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Install  latest node
nvm install node

# Install neovim
sudo apt install neovim -y

# Reload zshrc
source ~/.zshrc
