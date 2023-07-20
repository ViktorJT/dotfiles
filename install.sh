#!/bin/bash

# Install zsh
sudo apt update
sudo apt install zsh -y

# Set zsh as default shell
chsh -s $(which zsh)

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install starship prompt
sh -c "$(curl -fsSL https://starship.rs/install.sh)"


# Install pyenv

# MacOS
brew install pyenv

# Ubuntu 
# curl https://pyenv.run | bash

# Install latest python 3 version
pyenv install 3:latest


# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Install  latest node
nvm install node


# Install neovim
sudo apt install neovim -y

# Reload zshrc
source ~/.zshrc
