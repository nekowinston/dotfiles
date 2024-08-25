{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [ sccache ];

    sessionVariables = {
      RUSTC_WRAPPER = lib.getExe pkgs.sccache;
      SCCACHE_BUCKET = "sccache";
      SCCACHE_ENDPOINT = "https://s3.winston.sh/";
      SCCACHE_REGION = "eu-central-1";
    };
  };

  programs = {
    nushell.extraConfig = # nu
      ''
        let mc_credentials = try { ^mc alias ls main --json | from json }
        if ($mc_credentials | get -i accessKey | is-not-empty) {
          $env.AWS_ACCESS_KEY_ID = $mc_credentials.accessKey
          $env.AWS_SECRET_ACCESS_KEY = $mc_credentials.secretKey
        }
      '';
    zsh.envExtra = # bash
      ''
        export AWS_ACCESS_KEY_ID=$(mc alias ls main --json | ${lib.getExe pkgs.gojq} -r '.accessKey')
        export AWS_SECRET_ACCESS_KEY=$(mc alias ls main --json | ${lib.getExe pkgs.gojq} -r '.secretKey')
      '';
  };

}
