{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}: let
  mkSymlink = path: config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/wezterm/${path}";
in {
  # use the GUI version & config when we have a gui, else just get terminfo
  config = lib.mkMerge [
    (lib.mkIf (!config.isGraphical) {
      home.packages = [pkgs.wezterm.terminfo];
    })

    (lib.mkIf config.isGraphical {
      programs.wezterm = {
        enable = true;
        package = pkgs.nur.repos.nekowinston.wezterm-nightly;
      };

      xdg.configFile = {
        "wezterm/wezterm.lua".source = mkSymlink "wezterm.lua";
        "wezterm/config" = {
          source = mkSymlink "config";
          recursive = true;
        };
        "wezterm/bar".source = pkgs.fetchFromGitHub {
          owner = "nekowinston";
          repo = "wezterm-bar";
          sha256 = "sha256-3acxqJ9HMA5hASWq/sVL9QQjfEw5Xrh2fT9nFuGjzHM=";
          rev = "e96b81460b3ad11a7461934dcb7889ce5079f97f";
        };
        "wezterm/catppuccin".source = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "wezterm";
          sha256 = "sha256-McSWoZaJeK+oqdK/0vjiRxZGuLBpEB10Zg4+7p5dIGY=";
          rev = "b1a81bae74d66eaae16457f2d8f151b5bd4fe5da";
        };
      };

      programs.zsh.initExtra = ''
        if [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
          TERM=wezterm
          source ${config.programs.wezterm.package}/etc/profile.d/wezterm.sh
        fi
      '';
    })
  ];
}
