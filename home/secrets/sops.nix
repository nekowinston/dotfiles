{
  config,
  pkgs,
  ...
}: {
  sops = {
    gnupg.home = config.programs.gpg.homedir;
    defaultSopsFile = ./main.yaml;
    secrets = {
      "kubeconfig".path = "${config.xdg.configHome}/kube/kubeconfig";
    };
  };
}
