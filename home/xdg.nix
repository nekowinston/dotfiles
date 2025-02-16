# assortment of random bs that's needed
# to make apps use XDG directories
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  inherit (config.xdg)
    cacheHome
    configHome
    dataHome
    stateHome
    ;
  inherit (config.home) homeDirectory sessionVariables;
in
{
  home = {
    sessionVariables = {
      # histories
      HISTFILE = "${stateHome}/bash/history";
      LESSHISTFILE = "${stateHome}/less_history";
      SQLITE_HISTORY = "${stateHome}/sqlite_history";
      # CLIs
      AZURE_CONFIG_DIR = "${configHome}/azure";
      CUDA_CACHE_PATH = "${dataHome}/nv";
      DOCKER_CONFIG = "${configHome}/docker";
      MC_CONFIG_DIR = "${configHome}/mc";
      W3M_DIR = "${dataHome}/w3m";
      WAKATIME_HOME = "${dataHome}/wakatime";
      WINEPREFIX = "${dataHome}/wine";

      ## Languages
      # DotNET
      DOTNET_CLI_HOME = "${dataHome}/dotnet";
      NUGET_PACKAGES = "${configHome}/NuGetPackages";
      OMNISHARPHOME = "${configHome}/omnisharp";
      # Elm
      ELM_HOME = "${dataHome}/elm";
      # Go
      GOPATH = "${dataHome}/go";
      # Haskell
      STACK_ROOT = "${dataHome}/stack";
      # Java
      _JAVA_OPTIONS = lib.concatStringsSep " " (
        lib.mapAttrsToList lib.mesonOption {
          "java.util.prefs.userRoot" = "${configHome}/java";
          "javafx.cachedir" = "${cacheHome}/openjfx";
          "sbt.global.base" = "${dataHome}/sbt";
        }
      );
      GRADLE_USER_HOME = "${dataHome}/gradle";
      # JavaScript
      DENO_INSTALL_ROOT = "${dataHome}/deno";
      NODE_REPL_HISTORY = "${stateHome}/node_repl_history";
      NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
      # Python
      IPYTHONDIR = "${configHome}/ipython";
      # Ruby
      BUNDLE_USER_CACHE = "${cacheHome}/bundle";
      BUNDLE_USER_CONFIG = "${configHome}/bundle";
      BUNDLE_USER_PLUGIN = "${dataHome}/bundle";
      GEM_HOME = "${dataHome}/gem";
      GEM_SPEC_CACHE = "${cacheHome}/gem";
      # Rust
      CARGO_HOME = "${dataHome}/cargo";
      RUSTUP_HOME = "${dataHome}/rustup";
    };
    sessionPath =
      [
        "$HOME/.local/bin"
        "${sessionVariables.GOPATH}/bin"
        "${sessionVariables.CARGO_HOME}/bin"
        "${sessionVariables.DENO_INSTALL_ROOT}/bin"
      ]
      ++ (lib.optionals isDarwin [
        # fix `nix profile` not being in PATH on macOS
        "${stateHome}/nix/profile/bin"
      ]);
  };

  programs.gpg.homedir = lib.mkIf isLinux "${configHome}/gnupg";

  xdg = {
    enable = true;
    userDirs.enable = isLinux;
    cacheHome = "${homeDirectory}/.cache";
    configHome = "${homeDirectory}/.config";
    dataHome = "${homeDirectory}/.local/share";
    stateHome = "${homeDirectory}/.local/state";
    mimeApps = {
      enable = isLinux;
      defaultApplications = lib.genAttrs [
        "inode/directory"
        "application/gzip"
        "application/vnd.rar"
        "application/x-7z-compressed"
        "application/x-bzip"
        "application/x-bzip2"
        "application/x-compressed-tar"
        "application/x-tar"
        "application/zip"
      ] (_: "nautilus.desktop;org.gnome.Nautilus.desktop");
    };
  };
}
