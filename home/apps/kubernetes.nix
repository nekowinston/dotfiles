{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    cmctl
    dyff
    gojq
    jqp
    konf
    kubeconform
    kubectl
    kubectx
    kubepug
    (wrapHelm kubernetes-helm {
      plugins = [kubernetes-helmPlugins.helm-diff];
    })
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
