# assortment of random bs that's needed
# to make apps use XDG directories
{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in {
  home = {
    sessionVariables = {
      AZURE_CONFIG_DIR = "${config.xdg.configHome}/azure";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      CARGO_REGISTRIES_CRATES_IO_PROTOCOL = "sparse";
      CARGO_UNSTABLE_SPARSE_REGISTRY = "true";
      CUDA_CACHE_PATH = "${config.xdg.dataHome}/nv";
      DOCKER_CONFIG = "${config.xdg.configHome}/docker";
      GEM_HOME = "${config.xdg.dataHome}/gem";
      GEM_SPEC_CACHE = "${config.xdg.cacheHome}/gem";
      GOPATH = "${config.xdg.dataHome}/go";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
    };
    sessionPath = [
      "$HOME/.local/bin"
      "${config.xdg.dataHome}/krew/bin"
      "${config.home.sessionVariables.GOPATH}/bin"
      "${config.home.sessionVariables.CARGO_HOME}/bin"
    ];
  };

  home.activation.npmrc_xdg = ''
    export NPM_CONFIG_USERCONFIG="${config.home.sessionVariables.NPM_CONFIG_USERCONFIG}"
    ${pkgs.nodejs + "/bin/npm"} config set \
      prefix="${config.xdg.dataHome}/npm" \
      cache="${config.xdg.cacheHome}/npm" \
      init-module="${config.xdg.configHome}/npm/config/npm-init.js"
  '';

  # NOTE: workaround for gpgme on Darwin, since GUI apps aren't aware of $GNUPGHOME
  programs.gpg.homedir =
    if isDarwin
    then "${config.home.homeDirectory}/.gnupg"
    else "${config.xdg.configHome}/gnupg";

  xdg = {
    enable = true;
    userDirs.enable = isLinux;
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
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
