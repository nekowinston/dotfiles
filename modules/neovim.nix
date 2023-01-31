{ config, pkgs, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> {};
in
{
  home.sessionVariables = {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
  };

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;

    extraPackages = with pkgs; [
      # external deps
      fd
      ripgrep

      # python
      black
      isort
      nodePackages.pyright

      # lua
      stylua
      sumneko-lua-language-server

      # data
      taplo

      # go
      delve
      ginkgo
      gofumpt
      gopls
      impl
      mockgen

      # webdev
      nodePackages."@astrojs/language-server"
      nodePackages."@tailwindcss/language-server"
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.alex
      # (callPackage ../packages/emmet-ls {})
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server

      # etc
      deno
      ltex-ls
      nodePackages.prettier
      rnix-lsp
      pkgsUnstable.rust-analyzer
      proselint
      rustc
      rustfmt
      shfmt
      tree-sitter
      (callPackage ../packages/jq-lsp {})

      # needed for some plugin build steps
      cargo
      yarn
      unzip
      gcc
      gnumake
    ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink ./nvim;
    recursive = true;
  };
}
