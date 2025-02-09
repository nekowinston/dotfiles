{
  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
  };
  xdg.configFile."zellij".source = ./config;
}
