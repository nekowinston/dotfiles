{
  config,
  pkgs,
  ...
}: {
  sops = {
    gnupg.home = config.programs.gpg.homedir;
    defaultSopsFile = ./main.yaml;
    secrets = {
      "konf-ctp".path = "${config.home.homeDirectory}/.kube/konfs/store/ctp_ctp.yaml";
      "konf-fra1".path = "${config.home.homeDirectory}/.kube/konfs/store/fra1_fra1.yaml";
      "konf-work-prod".path = "${config.home.homeDirectory}/.kube/konfs/store/work-prod_work-prod.yaml";
      "konf-work-staging".path = "${config.home.homeDirectory}/.kube/konfs/store/work-staging_work-staging.yaml";
    };
  };
}
