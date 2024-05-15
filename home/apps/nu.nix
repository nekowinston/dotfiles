{ lib, pkgs, ... }:
let
  plugins = "${pkgs.nu_scripts}/share/nu_scripts";

  mkCompletions =
    completions:
    lib.concatStringsSep "\n" (
      builtins.map (
        el:
        let
          name = el.name or el;
          filename = el.filename or el;
        in
        "source ${plugins}/custom-completions/${name}/${filename}-completions.nu"
      ) completions
    );

  completions = [
    "cargo"
    "composer"
    "gh"
    "git"
    "just"
    "man"
    "nix"
    "npm"
    "pnpm"
    "poetry"
    "rg"
    "tar"
    {
      name = "tealdeer";
      filename = "tldr";
    }
    {
      name = "yarn";
      filename = "yarn-v4";
    }
  ];
in
{
  home.packages = [ pkgs.carapace ];
  programs.nushell = {
    enable = true;

    configFile.source = ./nu/config.nu;

    extraConfig =
      ''
        source ${plugins}/aliases/git/git-aliases.nu
      ''
      + mkCompletions completions;
  };

  xdg.configFile."nushell/config" = {
    source = ./nu/config;
    recursive = true;
  };
}
