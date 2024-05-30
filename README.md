# winston's dotfiles

[![flake check status](https://img.shields.io/github/actions/workflow/status/nekowinston/dotfiles/check.yml?label=flake%20check&logo=nixos&logoColor=%23fff&style=flat-square&color=f5c2e7)](https://github.com/nekowinston/dotfiles/actions/workflows/check.yml)
[![GitHub stars](https://img.shields.io/github/stars/nekowinston/dotfiles?style=flat-square&color=f5c2e7)](https://github.com/nekowinston/dotfiles/stargazers)
[![commit activity](https://img.shields.io/github/commit-activity/w/nekowinston/dotfiles?style=flat-square&label=commits&color=f5c2e7)](https://github.com/nekowinston/dotfiles/commits)
[![MIT license](https://img.shields.io/github/license/nekowinston/dotfiles?style=flat-square&color=f5c2e7)](https://github.com/nekowinston/dotfiles/blob/main/LICENSE)

Welcome to my cross-platform dots.
Focused on improving productivity, and reducing the pain of switching between operating systems.
Minimal rice, with a focus on getting the annoying stuff out of the way.

### Overview

Here's what you can find:

- **[WezTerm](https://wezfurlong.org/wezterm/)** as my terminal, with tmux-like keybindings
- **[Starship](https://starship.rs)** as my prompt
- **Firefox** with privacy-centered settings, though I don't use it heavily anymore.
- My **GPG** & **[Sops.nix](https://github.com/Mic92/sops-nix)** settings
- Other random bits of config tools I've collected over the years
- macOS:
  - **[Yabai](https://github.com/koekeishiya/yabai)** as my WM
- Linux:
  - **[sway](https://swaywm.org)** as my WM

**[Neovim](https://neovim.io)** used to be part of this repository, but now my config is fully reproducible & stored over [here](https://github.com/nekowinston/neovim.drv).

### Notes for a new install

This flake technically has an impurity at its core, because it assumes that it will be stored in `~/.config/flake` and will create symlinks pointing there.
This is so I can edit some dotfiles (e.g. VSCode `settings.json`) in place and have programs hot reload them.

#### macOS

##### Install the [Xcode Command Line Tools](https://developer.apple.com/download/all/)

```console
$ xcode-select --install
```

##### Install [Homebrew](https://brew.sh)

```console
$ curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
```

##### Exclude `/nix/` from Time Machine:

```console
$ sudo tmutil addexclusion -v /nix
```


### Building the flake

```console
$ nix --experimental-features "nix-command flakes" develop # enter the devShell
$ just switch
```

I personally use [`nix-direnv`](https://github.com/nix-community/nix-direnv) to automatically enter this devShell on my machines.
