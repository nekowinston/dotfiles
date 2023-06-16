# winston's dotfiles

[![flake check status](https://img.shields.io/github/actions/workflow/status/nekowinston/dotfiles/check.yml?label=flake%20check&logo=nixos&logoColor=%23fff&style=flat-square&color=f5c2e7)](https://github.com/nekowinston/dotfiles/actions/workflows/check.yml)
[![GitHub stars](https://img.shields.io/github/stars/nekowinston/dotfiles?style=flat-square&color=f5c2e7)](https://github.com/nekowinston/dotfiles/stargazers)
[![commit activity](https://img.shields.io/github/commit-activity/w/nekowinston/dotfiles?style=flat-square&label=commits&color=f5c2e7)](https://github.com/nekowinston/dotfiles/commits)
[![SLOC](https://img.shields.io/tokei/lines/github/nekowinston/dotfiles?style=flat-square&color=f5c2e7)](#)
[![MIT license](https://img.shields.io/github/license/nekowinston/dotfiles?style=flat-square&color=f5c2e7)](https://github.com/nekowinston/dotfiles/blob/main/LICENSE)

Welcome to my cross-platform dots.
Focused on improving productivity, and reducing the pain of switching between operating systems.
Minimal rice, with a focus on getting the annoying stuff out of the way.

### Overview

Here's what you can find:

- **[WezTerm](https://wezfurlong.org/wezterm/)** as my terminal, with tmux-like keybindings
- **[Neovim](https://neovim.io)** as my tui editor & my JetBrains IdeaVim config
- **[Neomutt](http://www.neomutt.org)** as my mail client
- **[Taskwarrior](https://taskwarrior.org)** for task management
- **[Starship](https://starship.rs)** as my prompt
- **Firefox** with privacy-centered settings
- My **GPG** & **[Sops.nix](https://github.com/Mic92/sops-nix)** settings
- Other random bits of config tools I've collected over the years
- The **[Catppuccin](https://github.com/catppuccin)** theme, wherever possible
- macOS:
  - **[Yabai](https://github.com/koekeishiya/yabai)** as my WM
- Linux:
  - **[sway](https://swaywm.org)** as my WM

### Notes for a new install

#### macOS

##### Install the [Xcode Command Line Tools](https://developer.apple.com/download/all/)

```sh
xcode-select --install
```

##### [Install Brew](https://brew.sh)

```sh
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
```

##### Exclude `/nix/` from Time Machine:

```sh
sudo tmutil addexclusion -v /nix
```

##### Initial build for the flake

```sh
nix build .#darwinConfigurations.sashimi.system
./result/sw/bin/darwin-rebuild switch --flake .
```
