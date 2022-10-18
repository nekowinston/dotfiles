FROM archlinux:base-devel

RUN pacman -Sy \
  base-devel \
  chezmoi \
  fd \
  git \
  go \
  neovim \
  nodejs \
  npm \
  python \
  ripgrep \
  starship \
  tree-sitter \
  ttf-nerd-fonts-symbols-common \
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

# copy the dotfiles
COPY --chown=demo:demo . /home/demo/.local/share/chezmoi
# make sure the ownership is correct
RUN sudo chown -R demo:demo /home/demo/.local

# install them
RUN chezmoi init
RUN chezmoi apply -x encrypted

# set up antigen
RUN zsh -c "zsh ~/.zshrc; exit 0"
# set up neovim with PackerSync
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# use zsh as the default shell
ENTRYPOINT ["/bin/zsh"]
