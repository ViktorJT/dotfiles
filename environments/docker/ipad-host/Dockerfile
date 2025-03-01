# Base image: Lightweight Ubuntu
FROM ubuntu:22.04

# Set non-interactive mode to prevent prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system tools
RUN apt update && apt install -y \
    zsh git curl wget neovim tmux mosh fzf ripgrep \
    && apt clean

# Set Zsh as the default shell for root
RUN chsh -s $(which zsh) root

# Install NVM (Node Version Manager)
ENV NVM_DIR="/root/.nvm"
RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# Load NVM and install the latest LTS version of Node.js
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install --lts && nvm use --lts"

# Install Starship prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# Install Oh My Zsh + Plugins
RUN rm -rf /root/.oh-my-zsh && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    mkdir -p /root/.oh-my-zsh/custom/plugins && \
    git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Ensure .config directory exists before linking dotfiles
# RUN mkdir -p /root/.config && \
#     rm -rf /root/Configs && \
#     git clone https://github.com/ViktorJT/Configs.git /root/Configs && \
#     ln -sf /root/Configs/.zshrc /root/.zshrc && \
#     ln -sf /root/Configs/nvim /root/.config/nvim && \
#     ln -sf /root/Configs/starship.toml /root/.config/starship.toml
	
# Ensure NVM is loaded in every shell session
RUN echo 'export NVM_DIR="/root/.nvm"' >> /root/.zshrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /root/.zshrc

# Set Zsh as the interactive shell
SHELL ["/usr/bin/zsh", "-c"]

# Start Zsh when entering the container
CMD ["zsh"]
