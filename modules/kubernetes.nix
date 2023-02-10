{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    dyff
    gojq
    jqp
    krew
    kubectl
    kubectx
    kubernetes-helm
    popeye
  ];
  home.sessionVariables = {
    KREW_ROOT = "${config.xdg.dataHome}/krew";
    KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
    KUBECONFIG = "${config.xdg.configHome}/kube/config";
    MINIKUBE_HOME = "${config.xdg.dataHome}/minikube";
  };
}
