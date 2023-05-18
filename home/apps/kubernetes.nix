{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (wrapHelm kubernetes-helm {plugins = [kubernetes-helmPlugins.helm-diff];})
    cmctl
    dyff
    gojq
    jqp
    konf
    kubecolor
    kubeconform
    kubectl
    kubectx
    kubepug
    kubeseal
    minikube
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

  programs.zsh = {
    initExtra = ''
      # kubecolor
      compdef kubecolor=kubectl
      # konf
      source <(konf-go shellwrapper zsh)
      source <(konf-go completion zsh)
      # ignore if konf store hasn't been initialized
      export KUBECONFIG=$(konf-go --silent set - || true)
    '';
  };

  sops.secrets = let
    konfStore = "${config.xdg.configHome}/.kube/konfs/store";
  in {
    "konf-ctp".path = "${konfStore}/ctp_ctp.yaml";
    "konf-fra1".path = "${konfStore}/fra1_fra1.yaml";
    "konf-work-prod".path = "${konfStore}/work-prod_work-prod.yaml";
    "konf-work-staging".path = "${konfStore}/work-staging_work-staging.yaml";
  };

  home.sessionVariables = {
    KREW_ROOT = "${config.xdg.dataHome}/krew";
    KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
    MINIKUBE_HOME = "${config.xdg.dataHome}/minikube";
  };
}
