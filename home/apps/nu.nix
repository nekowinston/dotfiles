{
  config,
  lib,
  pkgs,
  ...
}:
let
  nu_scripts = "${pkgs.nu_scripts}/share/nu_scripts";

  shellAliases = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (k: v: "alias ${k} = ${v}") config.home.shellAliases
  );

  mkCompletions =
    completions:
    lib.concatStringsSep "\n" (
      builtins.map (
        el:
        let
          name = el.name or el;
          filename = el.filename or el;
        in
        "source ${nu_scripts}/custom-completions/${name}/${filename}-completions.nu"
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

  command-not-found = pkgs.writeShellScript "command-not-found" ''
    source ${config.programs.nix-index.package}/etc/profile.d/command-not-found.sh
    command_not_found_handle "$@"
  '';
in
{
  programs.carapace.enable = true;
  programs.nushell = {
    enable = true;

    configFile.source = ./nu/config.nu;

    extraConfig =
      ''
        $env.config = ($env.config? | default {})
        $env.config.hooks = ($env.config.hooks? | default {})
        $env.config.hooks.command_not_found = {
          |cmd_name| (try { ${command-not-found} $cmd_name })
        }

        source ${nu_scripts}/aliases/git/git-aliases.nu
      ''
      + shellAliases
      + mkCompletions completions;
  };

  xdg.configFile."nushell/config".source = ./nu/config;
}
