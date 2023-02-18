{pkgs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in {
  programs.git = {
    enable = true;
    userName = "winston";
    userEmail = "hey@winston.sh";

    signing = {
      signByDefault = true;
      key = "A476C39610E53A689A57BD0D0B89BC45007EE9CC";
    };

    diff-so-fancy.enable = true;
    lfs.enable = true;

    ignores = [
      # general
      "*.log"
      ".DS_Store"
      # editors
      "*.swp"
      ".gonvim/"
      ".idea/"
      "ltex.dictionary*.txt"
      # nix-specific
      ".direnv/"
      ".envrc"
    ];

    # disable the macOS keychain, only use gopass
    package =
      if isDarwin
      then (pkgs.git.override {osxkeychainSupport = false;})
      else pkgs.git;

    extraConfig = {
      credential.helper = "gopass";
      init.defaultBranch = "main";
      push.default = "current";
      push.gpgSign = "if-asked";
      rebase.autosquash = true;
    };
  };
}
