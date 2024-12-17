{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  milspec = (pkgs.callPackage ../../_sources/generated.nix { }).milspec;

  vividMilspec = pkgs.runCommand "vivid-milspec" { nativeBuildInputs = [ pkgs.vivid ]; } ''
    mkdir -p $out
    for variant in dark light; do
      vivid generate "${milspec.src}/extras/vivid/milspec-''${variant}.yml" > "$out/''${variant}"
    done
  '';
in
{
  config = lib.mkIf config.isGraphical {
    home.packages = [ pkgs.dark-mode-ternary ];

    services.darkman = {
      enable = isLinux;
      settings = {
        lat = config.location.latitude;
        lng = config.location.longitude;
        usegeoclue = false;
      };
    };

    xdg.configFile.fsh.source = "${milspec.src}/extras/zsh-fast-syntax-highlighting";
    programs.zsh.initExtra = # bash
      ''
        zadm_sync() {
          local variant="$(dark-mode-ternary dark light)"

          export BAT_THEME="OneHalf''${(C)variant}"
          export LS_COLORS="$(cat "${vividMilspec}/''${variant}")"
          export STARSHIP_CONFIG__PALETTE="milspec_''${variant}"

          fast-theme "XDG:milspec-''${variant}" >/dev/null
        }
        add-zsh-hook precmd zadm_sync
      '';

    programs.nushell.extraConfig = # nu
      ''
        $env.config = ($env.config? | default {})
        $env.config.hooks = ($env.config.hooks? | default {})
        $env.config.hooks.pre_prompt = (
          $env.config.hooks.pre_prompt?
          | default []
          | append {||
            let variant = dark-mode-ternary "dark" "light"

            use ${milspec.src}/extras/nu/milspec.nu
            $env.config = $env.config? | default {}
            $env.config.color_config = (milspec -R $variant)

            $env.BAT_THEME = $"OneHalf($variant | str capitalize)"
            $env.LS_COLORS = (^cat $"${vividMilspec}/($variant)")
            $env.STARSHIP_CONFIG__PALETTE = "milspec_" + $variant
          }
        )
      '';
  };
}
