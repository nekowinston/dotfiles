FROM archlinux:base-devel

RUN pacman -Sy \
  base-devel \
  chezmoi \
  fd \
  git \
  go \
  nodejs \
  npm \
  python \
  ripgrep \
  starship \
  tree-sitter \
  ttf-nerd-fonts-symbols \
  unzip \
  zip \
  zsh \
  --noconfirm

# initialize the demo user
RUN useradd -m demo && \
  echo "demo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/demo
USER demo
WORKDIR /home/demo

# install yay, might be used at a later point
# RUN git clone https://aur.archlinux.org/yay-bin.git && \
#   cd yay-bin && \
#   makepkg -si --noconfirm && \
#   cd .. && \
#   rm -rf yay-bin

# install the latest neovim-nightly build
ADD --chown=demo:demo https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz /home/demo/nvim-linux64.tar.gz
RUN mkdir ./neovim && \
  tar -xzvf nvim-linux64.tar.gz -C . && \
  rm /home/demo/nvim-linux64.tar.gz && \
  sudo cp -r ./nvim-linux64/* /usr/ && \
  rm -rf ./neovim

# copy the dotfiles
COPY --chown=demo:demo . /home/demo/.local/share/chezmoi

# install them
RUN chezmoi init
RUN chezmoi apply -x encrypted

# set up antigen
RUN zsh -c "zsh ~/.zshrc; exit 0"
# set up neovim with PackerSync
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# use zsh as the default shell
ENTRYPOINT ["/bin/zsh"]
