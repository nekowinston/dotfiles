{lib, ...}:
with lib; let
  cfg = config.catppuccin;
in {
  imports = [
    ./bat
    ./btop
    # ./dunst
    ./dircolors
    ./k9s
    # ./lsd
    ./vscode
  ];

  options.catppuccin = {
    defaultTheme = mkOption {
      type = types.enum ["mocha" "macchiato" "frappe" "latte"];
      default = "mocha";
      description = "Choose a catppuccin bat theme";
    };
  };
}
