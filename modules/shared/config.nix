{
  lib,
  ...
}:
let
  inherit (lib) types;
in
{
  options = {
    dotfiles = lib.mkOption {
      type = types.submodule {
        options = {
          desktop = lib.mkOption {
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
          username = lib.mkOption {
            description = "The username of the user";
            type = types.str;
          };
        };
      };
    };
    isGraphical = lib.mkEnableOption "" // {
      description = "Whether the system is a graphical target";
    };
  };
}
