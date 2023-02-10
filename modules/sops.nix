{config, ...}: {
  # TODO: enable after sops supports nix-darwin
  sops = {
    gnupg.home = "${config.xdg.configHome}/gnupg";
    defaultSopsFile = ../secrets.yaml;
    secrets."kubernetes-work-prod" = {
      path = "${config.xdg.configHome}/kube/work-prod";
    };
  };
}
