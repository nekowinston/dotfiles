{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs.unstable; [
    cmctl
    dyff
    gojq
    jqp
    konf
    kubeconform
    kubectl
    kubectx
    kubepug
    kubernetes-helm
    minikube
    popeye
    pv-migrate
    velero
  ];

  home.shellAliases = {
    jq = "gojq";
    kcuc = "konf set";
    kcn = "konf ns";
  };

  home.sessionVariables = {
    KREW_ROOT = "${config.xdg.dataHome}/krew";
    KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
    MINIKUBE_HOME = "${config.xdg.dataHome}/minikube";
  };
}
