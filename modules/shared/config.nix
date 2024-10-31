{
  lib,
  ...
}:
let
  inherit (lib) types mkOption mkEnableOption;
in
{
  options = {
    dotfiles = mkOption {
      type = types.submodule {
        options = {
          desktop = mkOption {
            description = "The desktop environment to use";
            type = types.nullOr (
              types.enum [
                "cosmic"
                "gnome"
                "hyprland"
                "sway"
                "swayfx"
              ]
            );
          };
          username = mkOption {
            description = "The username of the user";
            type = types.str;
          };
        };
      };
    };
    isGraphical = mkEnableOption "" // {
      description = "Whether the system is a graphical target";
    };
  };
}
