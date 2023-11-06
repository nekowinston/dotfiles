{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  settingsJSON = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/vscode/settings.json";
  keybindingsJSON = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/vscode/keybindings.json";
in {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-marketplace; [
      adrianwilczynski.alpine-js-intellisense
      antfu.icons-carbon
      astro-build.astro-vscode
      bradlc.vscode-tailwindcss
      catppuccin.catppuccin-vsc-icons
      charliermarsh.ruff
      dbaeumer.vscode-eslint
      denoland.vscode-deno
      dhall.dhall-lang
      dhall.vscode-dhall-lsp-server
      eamodio.gitlens
      editorconfig.editorconfig
      esbenp.prettier-vscode
      github.copilot
      github.vscode-pull-request-github
      gitlab.gitlab-workflow
      golang.go
      graphql.vscode-graphql-syntax
      jnoortheen.nix-ide
      kamadorueda.alejandra
      leonardssh.vscord
      lunuan.kubernetes-templates
      mads-hartmann.bash-ide-vscode
      mikestead.dotenv
      mkhl.direnv
      mkhl.shfmt
      ms-kubernetes-tools.vscode-kubernetes-tools
      pkief.material-icon-theme
      redhat.vscode-yaml
      rust-lang.rust-analyzer
      serayuzgur.crates
      sumneko.lua
      tamasfe.even-better-toml
      tomoki1207.pdf
      unifiedjs.vscode-mdx
      usernamehw.errorlens
      valentjn.vscode-ltex
      vscodevim.vim
      webfreak.code-d
    ];
    mutableExtensionsDir = true;
  };

  home.file = lib.mkIf isDarwin {
    "Library/Application Support/Code/User/keybindings.json".source = keybindingsJSON;
    "Library/Application Support/Code/User/settings.json".source = settingsJSON;
  };
  xdg.configFile = lib.mkIf isLinux {
    "Code/User/keybindings.json".source = keybindingsJSON;
    "Code/User/settings.json".source = settingsJSON;
  };
  xdg.mimeApps.defaultApplications."text/plain" = "code.desktop";
}
