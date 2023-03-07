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
    kubectl
    kubectx
    kubernetes-helm
    popeye
    pv-migrate
    velero
  ];

  home.shellAliases.jq = "gojq";

  home.sessionVariables = {
    KREW_ROOT = "${config.xdg.dataHome}/krew";
    KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
    KUBECONFIG = "${config.xdg.configHome}/kube/config";
    MINIKUBE_HOME = "${config.xdg.dataHome}/minikube";
  };
}
