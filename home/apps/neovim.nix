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
      nodePackages.typescript
      nodePackages.typescript-language-server
      unstable.nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server

      # etc
      unstable.deno
      ltex-ls
      nodePackages.prettier
      rnix-lsp
      unstable.rust-analyzer
      proselint
      rustc
      rustfmt
      shfmt
      tree-sitter
      alejandra
      deadnix
      nur.repos.nekowinston.jq-lsp
      nur.repos.nekowinston.helm-ls
      nur.repos.bandithedoge.nodePackages.emmet-ls

      # needed for some plugin build steps
      cargo
      yarn
      unzip
      gcc
      gnumake
    ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/neovim";
    recursive = true;
  };
}