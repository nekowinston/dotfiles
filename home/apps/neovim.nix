{
  config,
  pkgs,
  flakePath,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;

    extraPackages = with pkgs.unstable; [
      # external deps
      fd
      ripgrep

      # python
      black
      isort
      nodePackages.pyright

      # lua
      stylua
      lua-language-server
      luaPackages.tl
      luaPackages.teal-language-server

      # data
      taplo

      # go
      go
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
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
      nodePackages.intelephense
      yarn

      # rust
      cargo
      rust-analyzer
      rustc
      rustfmt

      # etc
      deno
      ltex-ls
      nodePackages.prettier
      rnix-lsp
      proselint
      shellcheck
      shfmt
      tree-sitter
      alejandra
      deadnix
      pkgs.nur.repos.nekowinston.jq-lsp
      pkgs.nur.repos.nekowinston.helm-ls
      pkgs.nur.repos.bandithedoge.nodePackages.emmet-ls

      # needed for some plugin build steps
      gcc
      gnumake
      unzip
    ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/neovim";
    recursive = true;
  };
}
