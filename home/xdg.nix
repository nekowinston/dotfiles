# assortment of random bs that's needed
# to make apps use XDG directories
{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  inherit (config.xdg) cacheHome configHome dataHome;
  inherit (config.home) homeDirectory;
in {
  home = rec {
    sessionVariables = {
      AZURE_CONFIG_DIR = "${configHome}/azure";
      CARGO_HOME = "${dataHome}/cargo";
      CARGO_REGISTRIES_CRATES_IO_PROTOCOL = "sparse";
      CARGO_UNSTABLE_SPARSE_REGISTRY = "true";
      CUDA_CACHE_PATH = "${dataHome}/nv";
      DOCKER_CONFIG = "${configHome}/docker";
      GEM_HOME = "${dataHome}/gem";
      GEM_SPEC_CACHE = "${cacheHome}/gem";
      GOPATH = "${dataHome}/go";
      NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
      NODE_REPL_HISTORY = "${dataHome}/node_repl_history";
      RUSTUP_HOME = "${dataHome}/rustup";
      WINEPREFIX = "${dataHome}/wine";
      XCOMPOSECACHE = "${cacheHome}/X11/xcompose";
    };
    sessionPath = [
      "$HOME/.local/bin"
      "${dataHome}/krew/bin"
      "${sessionVariables.GOPATH}/bin"
      "${sessionVariables.CARGO_HOME}/bin"
    ];
  };

  # NOTE: workaround for gpgme on Darwin, since GUI apps aren't aware of $GNUPGHOME
  programs.gpg.homedir =
    if isDarwin
    then "${homeDirectory}/.gnupg"
    else "${configHome}/gnupg";

  xdg = {
    enable = true;
    userDirs.enable = isLinux;
    cacheHome = "${homeDirectory}/.cache";
    configHome = "${homeDirectory}/.config";
    dataHome = "${homeDirectory}/.local/share";
    mimeApps = {
      enable = isLinux;
      defaultApplications = {
        "inode/directory" = "thunar.desktop";
        "application/pdf" = "zathura.desktop";

        "text/plain" = "code.desktop";
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
    };
  };
}
