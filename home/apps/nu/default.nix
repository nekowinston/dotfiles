{
  config,
  lib,
  pkgs,
  ...
}:
let
  nu_scripts = "${pkgs.nu_scripts}/share/nu_scripts";

  aliases = mkAliases (config.home.shellAliases or { });

  mkAliases = aliases: lib.concatLines (lib.mapAttrsToList (k: v: "alias ${k} = ${v}") aliases);

  mkCompletions =
    completions:
    lib.concatLines (
      builtins.map (
        el: "source ${nu_scripts}/custom-completions/${el.name or el}/${el.filename or el}-completions.nu"
      ) completions
    );

  completions = mkCompletions [
    "cargo"
    "composer"
    "gh"
    "git"
    "just"
    "man"
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

  mkPlugins =
    plugins: lib.concatLines (builtins.map (plugin: "plugin add ${lib.getExe plugin}") plugins);

  plugins = mkPlugins (with pkgs.nushellPlugins; [ query ]);

  command-not-found = pkgs.writeShellScript "command-not-found" ''
    source ${config.programs.nix-index.package}/etc/profile.d/command-not-found.sh
    command_not_found_handle "$@"
  '';
in
{
  programs.carapace = {
    enable = true;
    # prefer my own completer
    enableNushellIntegration = false;
  };

  programs.nushell = {
    enable = true;

    configFile.source = ./config/config.nu;

    extraConfig = # nu
      ''
        $env.config = $env.config? | default {}
        $env.config.hooks = $env.config.hooks? | default {}
        $env.config.hooks.command_not_found = {|cmd_name|
          try { ${command-not-found} $cmd_name }
        }

        source ${nu_scripts}/aliases/git/git-aliases.nu
        source ${./config/keybindings.nu}

        ${lib.concatLines [
          completions
          plugins
          aliases
        ]}
      '';
    extraEnv = # nu
      ''
        $env.MANPAGER = "bat -l man -p"
        $env.ENV_CONVERSIONS = {
          "PATH": {
            from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
            to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
          }
          "Path": {
            from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
            to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
          }
        }
      '';
  };
}
