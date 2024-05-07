{ pkgs, ... }:
let
  inherit (pkgs.tmuxPlugins) mkTmuxPlugin;

  menus = mkTmuxPlugin {
    pluginName = "menus";
    version = "unstable-2024-04-09";
    src = pkgs.fetchFromGitHub {
      owner = "jaclu";
      repo = "tmux-menus";
      rev = "66700dd790374d40482d836b3e12e88231da79e6";
      sha256 = "sha256-Q0zVLIQ9f0KTO1Y3gDJU+5CbfnpGeUQhp1OPaml1FuU=";
    };
  };
  themepack = mkTmuxPlugin {
    pluginName = "themepack";
    version = "unstable-2022-12-23";
    src = pkgs.fetchFromGitHub {
      owner = "jimeh";
      repo = "tmux-themepack";
      rev = "7c59902f64dcd7ea356e891274b21144d1ea5948";
      sha256 = "sha256-c5EGBrKcrqHWTKpCEhxYfxPeERFrbTuDfcQhsUAbic4=";
    };
  };
in
{
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    prefix = "C-s";
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = menus;
        extraConfig = ''
          set -g @menus_location_x 'C'
          set -g @menus_location_y 'C'
          set -g @menus_trigger 'm'

          # nix-specific, cache dir would be read-only
          set -g @menus_use_cache 'no'
        '';
      }
      {
        plugin = jump;
        extraConfig = "set -g @jump-key 'f'";
      }
      {
        plugin = open;
        extraConfig = "set -g @open-S 'https://duckduckgo.com/?q='";
      }
      {
        plugin = urlview;
        extraConfig = "set -g @urlview-key 'u'";
      }
      {
        plugin = themepack;
        extraConfig = "set -g @themepack 'basic'";
      }
    ];
    terminal = "tmux-256color";

    baseIndex = 1;
    clock24 = true;
    mouse = true;

    keyMode = "vi";
    customPaneNavigationAndResize = true;

    extraConfig = ''
      # neovim fixes
      set-option -g terminal-overrides ',xterm-256color:RGB'
      set-option -g focus-events on
      set-option -sg escape-time 10

      # split with | and -
      unbind-key \\
      unbind-key -
      bind-key \\ split-window -h -c "#{pane_current_path}"
      bind-key -  split-window -v -c "#{pane_current_path}"

      # couple of vi mode keybinds
      unbind -T copy-mode-vi Space; # Default for begin-selection
      unbind -T copy-mode-vi Enter; # Default for copy-selection
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "clipcopy"
    '';
  };
}
