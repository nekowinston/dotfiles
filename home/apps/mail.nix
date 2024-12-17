{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkIcon = icon: "\"${icon}\"";
in
{
  age.secrets."aerc-personal.conf".path = "${config.xdg.configHome}/aerc/accounts.conf";

  programs.aerc = {
    enable = true;
    extraConfig = {
      general = {
        default-save-path = "~/Downloads";
        pgp-provider = "gpg";
        # agenix manages the accounts.conf,
        # so the permissions appear unsafe to aerc
        unsafe-accounts-conf = true;
        enable-osc8 = true;
      };
      compose = {
        header-layout = "To,From,Subject";
        address-book-cmd = "${lib.getExe pkgs.aba} ls '%s'";
        file-picker-cmd =
          with config.programs.fzf;
          lib.mkIf enable "${lib.getExe package} --multi --query=%s";
        empty-subject-warning = true;
        no-attachment-warning = "^[^>]*attach(ed|ment)";
      };
      ui =
        {
          styleset-name = "milspec-dark";

          dirlist-tree = true;
          border-char-horizontal = "─";
          border-char-vertical = "│";

          index-columns = "flags:8,name<20%,subject,date>=";

          threading-enabled = true;
          # prettier thread borders, copied from the aerc-config manpage
          thread-prefix-tip = "";
          thread-prefix-indent = "";
          thread-prefix-stem = "│";
          thread-prefix-limb = "─";
          thread-prefix-folded = "+";
          thread-prefix-unfolded = "";
          thread-prefix-first-child = "┬";
          thread-prefix-has-siblings = "├";
          thread-prefix-orphan = "┌";
          thread-prefix-dummy = "┬";
          thread-prefix-lone = " ";
          thread-prefix-last-sibling = "╰";
        }
        # quote the icons to make the icons double-width
        // builtins.mapAttrs (n: v: mkIcon v) {
          icon-encrypted = " ";
          icon-signed = " ";
          icon-unknown = " ";
          icon-invalid = " ";
          icon-attachment = " ";
          icon-new = " ";
          icon-old = " ";
          icon-replied = " ";
          icon-flagged = " ";
          icon-marked = " ";
          icon-draft = " ";
          icon-deleted = " ";
        };
      filters = {
        "text/calendar" = "calendar";
        "text/html" = "html | colorize";
        "text/plain" = "wrap -w 120 | colorize";
        "message/delivery-status" = "colorize";
        "message/rfc822" = "colorize";
      };
      openers = {
        "application/pdf" = lib.mkIf config.programs.zathura.enable "zathura";
      };
    };
  };
}
