{ lib, ... }:
let
  inherit (builtins) map toString;
  inherit (lib) listToAttrs nameValuePair range;

  genWorkspaceBind =
    lhs: rhs:
    map (i: nameValuePair (lhs i) (rhs (if i == "0" then "10" else i))) (map toString (range 0 9));
in
{
  services.aerospace = {
    enable = true;
    settings = {
      after-startup-command = [
        "layout tiles"
        "balance-sizes"
      ];

      exec.inherit-env-vars = true;

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
