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

  home.sessionVariables = {
    KREW_ROOT = "${config.xdg.dataHome}/krew";
    KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
    MINIKUBE_HOME = "${config.xdg.dataHome}/minikube";
  };
}
