{config, ...}: {
  sops = {
    gnupg.home = config.programs.gpg.homedir;
    defaultSopsFile = ./main.yaml;
  };
}
