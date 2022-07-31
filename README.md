# winston's dotfiles

Welcome to my cross-platform dots. Focused on improving productivity, and reducing the pain of switching between operating systems. Minimal rice, focus on getting the annoying stuff out of the way.

Everything is managed with [chezmoi](https://chezmoi.io), the best dotfile manager for cross-platform dotfiles. This also means that encrypted files are included, which require *my personal PGP key*.

**NB: I don't recommend** that you use `chezmoi apply`, *unless you're me!*\
It **will** attempt to overwrite your config files, including files in `~/.gnupg` and `~/.ssh`, if you're not careful.\
That being said, *if you still want to use chezmoi*, use `chezmoi apply -x encrypted`, which will install the dotfiles without requiring my PGP key.

I recommend that you [familiarize yourself with chezmoi](https://www.chezmoi.io/quick-start/) first, if you choose to go the 2nd route.

### Demo Dockerfile

I've built a Docker container based on Arch, so that you can check out *most* of the setup, without the risk to *your personal dotfiles*. You give check it out via:

```bash
docker pull ghcr.io/nekowinston/dotfiles/dotfiles:latest
docker run -it ghcr.io/nekowinston/dotfiles/dotfiles
```

Note that TreeSitter and Mason will install on the first launch, which is not ideal. Making this a smoother experience is on my [to-do](#to-do).

### Overview

Here's what's included:

**Productivity**:
- [WezTerm](https://wezfurlong.org/wezterm/) as the terminal, with tmux-like keybindings.
- [ranger](https://ranger.github.io) as the file browser.
- [neovim](https://neovim.io) as the editor:
  - LSP completion with [nvim-cmp](https://github.com/hrsh7th/nvim-cmp).
  - LSP server installation with [Mason](https://github.com/williamboman/mason.nvim).
  - Fuzzy file search via [Telescope](https://github.com/nvim-telescope/telescope.nvim).
  - Syntax highlighting with [TreeSitter](https://github.com/nvim-treesitter/nvim-treesitter).
  - [vimwiki](https://github.com/vimwiki/vimwiki/tree/dev) for note-taking & personal wikis.
- [neomutt](http://www.neomutt.org) as the mail client:
  - Dockerized [pandoc](https://pandoc.org) to write HTML emails.
  - [mutt-wizard](https://github.com/lukesmithxyz/mutt-wizard) for management, hence:
    - [isync](https://isync.sourceforge.io) (mbsync) for syncing IMAP.
    - [msmtp](https://marlam.de/msmtp/) for sending via SMTP.
    - [notmuch](https://notmuchmail.org) for indexing.
    - [pass](https://www.passwordstore.org/) for passwords.
    - [vdirsyncer](https://github.com/pimutils/vdirsyncer) for contacts sync.
    - [w3m](https://salsa.debian.org/debian/w3m) to read HTML emails.
- [taskwarrior](https://taskwarrior.org) for task management:
  - [bugwarrior](https://github.com/ralphbean/bugwarrior) for ticket integration.
  - [taskwiki](https://github.com/tools-life/taskwiki) for management in nvim.
- [tmux](https://github.com/tmux/tmux) configuration for remote servers.
- [qutebrowser](https://github.com/qutebrowser/qutebrowser) as *an alternative* browser. I use Firefox + Vimium as my daily driver.

**Rice**:
- The [catppuccin](https://github.com/catppuccin) theme, wherever possible.
- macOS:
  - [Yabai](https://github.com/koekeishiya/yabai) as the window manager.
  - [SketchyBar](https://github.com/FelixKratz/SketchyBar) as an alternative to the native menubar
- Linux:
  - [i3](https://github.com/i3/i3) as the window manager.
  - [polybar](https://github.com/polybar/polybar) as the menubar.
- Custom binaries for both menubars.

### Performance

My philosophy regarding the neovim setup, can be roughly summed up as:

> productivity > startup time

I have no use for an editor that starts up fast, but breaks all the time or lacks a bunch of features. My average startup time is 120ms on an Apple Silicone M1 Max CPU. I'm happy to improve it, but not at the cost of an unreasonably complex setup.

### To-do

- Main files
  - [ ] Alfred workflows
  - [ ] Firefox dots, such as a `user.js` and `userChrome.css`
  - [ ] Re-work the `rofi` setup
- Docker Container
  - [ ] Install more dependencies for a smoother user experience.
  - [ ] Pre-install TreeSitter and LSP servers.
