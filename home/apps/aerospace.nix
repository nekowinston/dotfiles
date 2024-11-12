{
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) map toString;
  inherit (lib) listToAttrs nameValuePair range;
  inherit (pkgs.stdenv) isDarwin;

  genWorkspaceBind = lhs: rhs: map (i: nameValuePair (lhs i) (rhs i)) (map toString (range 0 9));
in
{
  programs.aerospace = {
    enable = isDarwin;
    settings = {
      start-at-login = true;

      after-startup-command = [
        "layout tiles"
        "balance-sizes"
        "exec-and-forget ${lib.getExe pkgs.jankyborders} style=square active_color=0xffff66a1 blur_radius=0 inactive_color=0xffd69fd6 hidpi=on width=3"
      ];

      exec.inherit-env-vars = true;
      exec-on-workspace-change = lib.mkIf false [
        "/bin/sh"
        "-c"
        "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=\"$AEROSPACE_FOCUSED_WORKSPACE\""
      ];

      gaps.inner = {
        horizontal = 3;
        vertical = 3;
      };
      gaps.outer = {
        bottom = 2;
        left = 2;
        right = 2;
        top = 2;
      };

      mode.main.binding =
        {
          cmd-shift-enter = "exec-and-forget open -na \"$HOME/Applications/Home Manager Apps/WezTerm.app\"";

          ctrl-cmd-e = "balance-sizes";
          shift-cmd-d = "layout tiling floating";
          shift-cmd-r = "mode resize";

          ctrl-cmd-h = "focus left";
          ctrl-cmd-j = "focus down";
          ctrl-cmd-k = "focus up";
          ctrl-cmd-l = "focus right";

          shift-cmd-h = "move left";
          shift-cmd-j = "move down";
          shift-cmd-k = "move up";
          shift-cmd-l = "move right";

          # suppress hiding Apps
          cmd-alt-h = [ ];
          cmd-h = [ ];

          alt-enter = "fullscreen";
        }
        // (listToAttrs (
          [ ]
          ++ (genWorkspaceBind (v: "ctrl-cmd-${v}") (v: "workspace ${v}"))
          ++ (genWorkspaceBind (v: "shift-cmd-${v}") (v: [
            "move-node-to-workspace ${v}"
            "workspace ${v}"
          ]))
        ));
      mode.resize.binding = {
        esc = "mode main";
        h = "resize width +50";
        j = "resize height +50";
        k = "resize height -50";
        l = "resize width -50";
      };
    };
  };
}
