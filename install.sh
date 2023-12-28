#!/bin/bash

echo "What are you bootstrapping?"
options=("Personal machine" "Server")

select opt in "${options[@]}"
do
    case $opt in
        "Client")
            echo "Installing everything with apt..."
            # Add installation commands here
            sudo apt update
            sudo apt install zsh -y

            # Install pyenv

            # MacOS
            # brew install pyenv

            # Ubuntu 
            # curl https://pyenv.run | bash

            # Install latest python 3 version
            # pyenv install 3:latest
            
            break
            ;;
        "Server")
            echo "Installing server stuff with yum..."
            # Add installation commands here
            sudo yum update -y
            sudo yum install zsh -y

            # if chsh (change shell) isn't available: install util-linux-user which has it
            if ! command -v chsh &> /dev/null
            then
                sudo yum install util-linux-user -y
            fi

            break
            ;;
        *) echo "Invalid option $REPLY";;
    esac
    break
done

# Check if Zsh is installed successfully
if [ -f /bin/zsh ] || [ -f /usr/bin/zsh ]; then
    echo "Zsh successfully installed"
else
    echo "Zsh installation failed"
    exit 1
fi

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
