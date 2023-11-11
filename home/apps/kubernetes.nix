{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (wrapHelm kubernetes-helm {
      plugins = [kubernetes-helmPlugins.helm-diff];
    })
    cmctl
    dyff
    gojq
    jqp
    konf
    krew
    kubecolor
    kubeconform
    kubectl
    kubectl-view-secret
    kubectx
    kubepug
    kubeseal
    minikube
    minio-client
    popeye
    pv-migrate
    velero
  ];

  home.shellAliases = {
    jq = "gojq";
    kcn = "konf ns";
    kcuc = "konf set";
    kubectl = "kubecolor";
  };

  # programs.zsh = {
  #   initExtra = ''
  #     # kubecolor
  #     compdef kubecolor=kubectl
  #     # konf
  #     source <(konf-go shellwrapper zsh)
  #     source <(konf completion zsh)
  #     # ignore if konf store hasn't been initialized
  #     konf --silent set -
  #   '';
  # };

  # sops.secrets = let
  #   konfStore = "${config.home.homeDirectory}/.kube/konfs/store";
  # in {
  #   "konf-ctp".path = "${konfStore}/ctp_ctp.yaml";
  #   "konf-work-prod".path = "${konfStore}/work-prod_work-prod.yaml";
  #   "konf-work-staging".path = "${konfStore}/work-staging_work-staging.yaml";
  # };

  home.sessionVariables = {
    KREW_ROOT = "${config.xdg.dataHome}/krew";
    KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
    MINIKUBE_HOME = "${config.xdg.dataHome}/minikube";
  };
}
