{ config, pkgs, ... }:
{
  programs.zsh.initExtra = ''
    # kubecolor
    compdef kubecolor=kubectl
    # konf
    source <(konf-go shellwrapper zsh)
    source <(konf completion zsh)
    # ignore if konf store hasn't been initialized
    konf set - >/dev/null 2>&1
  '';

  home = {
    packages = with pkgs; [
      (wrapHelm kubernetes-helm { plugins = [ kubernetes-helmPlugins.helm-diff ]; })
      cmctl
      dyff
      gojq
      jqp
      konf
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

    sessionVariables = {
      KREW_ROOT = "${config.xdg.dataHome}/krew";
      KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
      MINIKUBE_HOME = "${config.xdg.dataHome}/minikube";
    };

    shellAliases = {
      jq = "gojq";
      kcn = "konf ns";
      kcuc = "konf set";
      kubectl = "kubecolor";
    };
  };
}
