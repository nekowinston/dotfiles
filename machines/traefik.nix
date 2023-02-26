# this is half baked, so it's not enabled yet
{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in {
  # add the traefik user to the docker group for socket access
  users = lib.mkIf isLinux {
    users.traefik.extraGroups = ["docker"];
  };

  services = lib.mkIf isLinux {
    traefik = {
      enable = true;

      staticConfigOptions = {
        entryPoints = {
          http = {
            address = ":80";
            http.redirections.entryPoint = {
              to = "https";
              scheme = "https";
              permanent = true;
            };
          };
          https.address = ":443";
        };
        providers = {
          docker = {
            endpoint = "unix:///var/run/docker.sock";
            exposedByDefault = false;
          };
        };
        api = {
          dashboard = true;
          insecure = false;
          debug = false;
        };
        log.level = "INFO";
        accessLog = true;
      };

      dynamicConfigOptions = {
        tls.options.default.minVersion = "VersionTLS13";
        tls.stores.default.defaultCertificate = {
          # this would be an impurity, since it's generated inside the flake
          # via mkcert, another reason why it's deactivated as of now
          certFile = builtins.toString ../certs/local.crt;
          keyFile = builtins.toString ../certs/local.key;
        };
        http.routers.traefik = {
          entryPoints = ["http" "https"];
          rule = "Host(`traefik.this.test`)";
          tls = true;
          service = "api@internal";
        };
      };
    };
  };
}
