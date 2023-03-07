# assortment of random bs that's needed
# to make apps use XDG directories
{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in {
  home.sessionVariables = {
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    CUDA_CACHE_PATH = "${config.xdg.dataHome}/nv";
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    GEM_HOME = "${config.xdg.dataHome}/gem";
    GEM_SPEC_CACHE = "${config.xdg.cacheHome}/gem";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
  };

  home.activation.npmrc_xdg = ''
    export NPM_CONFIG_USERCONFIG="${config.home.sessionVariables.NPM_CONFIG_USERCONFIG}"
    ${pkgs.nodejs + "/bin/npm"} config set \
      prefix="${config.xdg.dataHome}/npm" \
      cache="${config.xdg.cacheHome}/npm" \
      init-module="${config.xdg.configHome}/npm/config/npm-init.js"
  '';

  programs.go.goPath = ".local/share/go";
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
  };
}
