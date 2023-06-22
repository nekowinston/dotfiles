{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in {
  sops.secrets."gitconfig-work".path = "${config.xdg.configHome}/git/gitconfig-work";
  programs.git.includes = [
    {
      condition = "gitdir:~/Code/work/";
      path = config.sops.secrets.gitconfig-work.path;
    }
  ];

  programs.git = {
    enable = true;
    userName = "winston";
    userEmail = "hey@winston.sh";

    signing = {
      signByDefault = true;
      key = "A476C39610E53A689A57BD0D0B89BC45007EE9CC";
    };

    diff-so-fancy.enable = true;
    aliases = {
      # get plain text diffs for patches
      patch = "!git --no-pager diff --no-color";
      # zip the current repo
      gzip = "!git archive --format=tar.gz --output=$(basename $(git rev-parse --show-toplevel)).tar.gz $(git rev-parse --short HEAD)";
      zip = "!git archive --format=zip --output=$(basename $(git rev-parse --show-toplevel)).zip $(git rev-parse --short HEAD)";
      # for those 3am commits
      yolo = "!git commit -m \"chore: $(curl -s whatthecommit.com/index.txt)\"";
    };

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
      url = {
        "https://github.com/".insteadOf = "github:";
        "https://github.com/catppuccin/".insteadOf = "catppuccin:";
        "https://github.com/nekowinston/".insteadOf = "nekowinston:";
        "https://gitlab.com/".insteadOf = "gitlab:";
      };
    };
  };
}
