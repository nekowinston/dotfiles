{
  config,
  flakePath,
  pkgs,
  ...
}: {
  programs.wezterm = {
    enable = true;
    # package = pkgs.nur.repos.nekowinston.wezterm-nightly;
    extraConfig = ''
      package.path = "${flakePath}/home/apps/wezterm/?.lua;" .. package.path;
      return require("config")
    '';
  };

  programs.zsh.initExtra = ''
    if [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
      TERM=wezterm
      source ${config.programs.wezterm.package}/etc/profile.d/wezterm.sh
    fi
  '';
}
