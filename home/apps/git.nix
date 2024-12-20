{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  programs.git.includes = [
    {
      condition = "gitdir:~/Code/work/";
      path = config.age.secrets."gitconfig-work".path;
    }
    {
      condition = "gitdir:~/Code/freelance/";
      path = config.age.secrets."gitconfig-freelance".path;
    }
  ];

  # use fsmonitor
  home.packages = [
    pkgs.rs-git-fsmonitor
    pkgs.watchman
  ];

  # disable loading the systme config on Darwin, where Nix tells it to use the
  # osxkeychain credential manager.
  home.sessionVariables = lib.mkIf isDarwin {
    GIT_CONFIG_NOSYSTEM = 1;
  };

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
      yolo = "!git commit -m \"chore: $(curl -s https://whatthecommit.com/index.txt)\"";
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
      "ltex.*.txt"
      # nix-specific
      ".direnv/"
      ".envrc"
    ];

    extraConfig = {
      core.fsmonitor = "rs-git-fsmonitor";
      credential.helper = "gopass";
      init.defaultBranch = "main";
      push.default = "current";
      push.gpgSign = "if-asked";
      rebase.autosquash = true;
      url = {
        "https://github.com/".insteadOf = "gh:";
        "https://github.com/nekowinston/".insteadOf = "winston:";
        "https://gitlab.com/".insteadOf = "gl:";
      };
    };
  };
}
