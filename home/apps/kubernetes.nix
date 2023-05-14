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
      # open last konf on new shell session, only if konf store has been initialized
      [[ -d ~/.kube/konfs/store ]] && export KUBECONFIG=$(konf-go --silent set -)
    '';
  };

  home.sessionVariables = {
    KREW_ROOT = "${config.xdg.dataHome}/krew";
    KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
    MINIKUBE_HOME = "${config.xdg.dataHome}/minikube";
  };
}
