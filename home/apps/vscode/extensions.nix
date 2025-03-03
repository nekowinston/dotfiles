{ pkgs, ... }:
let
  # pulling from different package sets:
  # - pkgs.vscode-extensions:
  #   pinned releases from inputs.nixpkgs.
  extNixpkgs = with pkgs.vscode-extensions; [
    # patches
    ms-python.python
    ms-python.vscode-pylance
    # locked to the latest release
    ms-vscode-remote.remote-ssh
    ms-vscode.hexeditor
    ms-vscode.live-server
    ms-vscode.test-adapter-converter
    sumneko.lua
    # needs a pinned release
    github.vscode-pull-request-github
    # pulling in extra binaries, patched for nix
    valentjn.vscode-ltex
  ];

  # - pkgs.vscode-marketplace-release:
  #   pinned releases from inputs.nix-vscode-extensions.
  #   these install the latest rather than the nightly version
  extPinnedFlake = with pkgs.vscode-marketplace-release; [
    rust-lang.rust-analyzer
    vadimcn.vscode-lldb
  ];

  # - pkgs.vscode-marketplace:
  #   rolling/nightly releases from inputs.nix-vscode-extensions
  # pinned releases; these install the latest rather than the nightly version
  extRollingFlake = with pkgs.vscode-marketplace; [
    # some default config patching to make these work without needing devShells all the time.
    # other extensions like Go/Rust are only really used with devShells,
    # nix & shell are universal enough for me to want them everywhere.
    (jnoortheen.nix-ide.overrideAttrs (prev: {
      nativeBuildInputs = prev.nativeBuildInputs ++ [
        pkgs.jq
        pkgs.moreutils
      ];
      postInstall = ''
        cd "$out/$installPrefix"
        jq -e '
          .contributes.configuration.properties."nix.enableLanguageServer".default =
            "true" |
          .contributes.configuration.properties."nix.serverPath".default =
            "${pkgs.nixd}/bin/nixd"
        ' < package.json | sponge package.json
      '';
    }))
    (mads-hartmann.bash-ide-vscode.overrideAttrs (prev: {
      nativeBuildInputs = prev.nativeBuildInputs ++ [
        pkgs.jq
        pkgs.moreutils
      ];
      postInstall = ''
        cd "$out/$installPrefix"
        jq -e '
          .contributes.configuration.properties."bashIde.shellcheckPath".default =
            "${pkgs.shellcheck}/bin/shellcheck"
        ' < package.json | sponge package.json
      '';
    }))
    (mkhl.shfmt.overrideAttrs (prev: {
      nativeBuildInputs = prev.nativeBuildInputs ++ [
        pkgs.jq
        pkgs.moreutils
      ];
      postInstall = ''
        cd "$out/$installPrefix"
        jq -e '
          .contributes.configuration.properties."shfmt.executablePath".default =
            "${pkgs.shfmt}/bin/shfmt"
        ' < package.json | sponge package.json
      '';
    }))
    adrianwilczynski.alpine-js-intellisense
    antfu.icons-carbon
    arcanis.vscode-zipfs
    astro-build.astro-vscode
    bashmish.es6-string-css
    biomejs.biome
    bradlc.vscode-tailwindcss
    charliermarsh.ruff
    dawidd6.debian-vscode
    dbaeumer.vscode-eslint
    denoland.vscode-deno
    editorconfig.editorconfig
    esbenp.prettier-vscode
    geequlim.godot-tools
    github.vscode-github-actions
    golang.go
    graphql.vscode-graphql-syntax
    gruntfuggly.todo-tree
    haskell.haskell
    hbenl.vscode-test-explorer
    jock.svg
    justusadam.language-haskell
    mikestead.dotenv
    mkhl.direnv
    oscarotero.vento-syntax
    pkief.material-icon-theme
    redhat.vscode-yaml
    ryanluker.vscode-coverage-gutters
    serayuzgur.crates
    tamasfe.even-better-toml
    tobermory.es6-string-html
    tomoki1207.pdf
    unifiedjs.vscode-mdx
    usernamehw.errorlens
    vscodevim.vim
  ];
in
{
  programs.vscode = {
    profiles.default.extensions = extNixpkgs ++ extPinnedFlake ++ extRollingFlake;
    mutableExtensionsDir = true;
  };
}
