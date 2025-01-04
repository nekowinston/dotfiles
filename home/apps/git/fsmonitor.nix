{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rs-git-fsmonitor
    # the rs-git-fsmonitor wrapper already includes it in the binpath, but
    # watchman offers management CLI
    watchman
  ];
  programs.git.extraConfig.core.fsmonitor = "rs-git-fsmonitor";
}
