{ config, lib, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
in

{
  nixpkgs.overlays = [(self: super: {
    meli = super.meli.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ lib.optionals isDarwin [
        pkgs.darwin.apple_sdk.frameworks.CoreServices 
      ];
      meta = old.meta // {
        platforms = lib.platforms.linux ++ lib.platforms.darwin;
        broken = false;
      };
    });
  })];

  accounts.email.maildirBasePath = "${config.xdg.dataHome}/mail";

  accounts.email.accounts = {
    "personal" = {
      primary = true;
      passwordCommand = "${lib.getExe pkgs.gopass} -o mail/personal";
      maildir.path = "personal";

      aliases = [ "hey@winston.sh" ];

      imap = {
        host = "imap.fastmail.com";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "smtp.fastmail.com";
        port = 465;
        tls.enable = true;
      };

      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };

      imapnotify = {
        enable = true;
        onNotify = "${lib.getExe pkgs.isync} %s";
        onNotifyPost = "${lib.getExe pkgs.notmuch} new && ${lib.getExe pkgs.libnotify} 'New mail arrived'";
      };

      msmtp.enable = true;
      neomutt = {
        enable = true;
      };
      notmuch.enable = true;
    };
  };

  home.packages = with pkgs; [ w3m ];

  services.imapnotify.enable = isLinux;

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
    neomutt = {
      enable = true;
      sidebar.enable = true;
      sort = "reverse-threads";
      vimKeys = true;
      extraConfig = "";
      settings = {
        mailcap_path = "$HOME/.config/neomutt/mailcap:$mailcap_path";
      };
      binds = [
        { map = [ "index" "pager" ]; key = "i"; action = "noop"; }
        { map = [ "index" "pager" ]; key = "g"; action = "noop"; }
        { map = [ "index" ]; key = "\\Cf"; action = "noop"; }
        { map = [ "index" "pager" ]; key = "M"; action = "noop"; }
        { map = [ "index" "pager" ]; key = "C"; action = "noop"; }
        { map = [ "index" ]; key = "gg"; action = "first-entry"; }
        { map = [ "index" ]; key = "j"; action = "next-entry"; }
        { map = [ "index" ]; key = "k"; action = "previous-entry"; }
        { map = [ "attach" ]; key = "<return>"; action = "view-mailcap"; }
        { map = [ "attach" ]; key = "l"; action = "view-mailcap"; }
        { map = [ "editor" ]; key = "<space>"; action = "noop"; }
        { map = [ "index" ]; key = "G"; action = "last-entry"; }
        { map = [ "index" ]; key = "gg"; action = "first-entry"; }
        { map = [ "pager" "attach" ]; key = "h"; action = "exit"; }
        { map = [ "pager" ]; key = "j"; action = "next-line"; }
        { map = [ "pager" ]; key = "k"; action = "previous-line"; }
        { map = [ "pager" ]; key = "l"; action = "view-attachments"; }
        { map = [ "index" ]; key = "D"; action = "delete-message"; }
        { map = [ "index" ]; key = "U"; action = "undelete-message"; }
        { map = [ "index" ]; key = "L"; action = "limit"; }
        { map = [ "index" ]; key = "h"; action = "noop"; }
        { map = [ "index" ]; key = "l"; action = "display-message"; }
        { map = [ "index" "query" ]; key = "<space>"; action = "tag-entry"; }
        { map = [ "browser" ]; key = "h"; action = "goto-parent"; }
        # { map = [ "browser" ]; key = "h"; action = "'<change-dir><kill-line>..<enter>' \"Go to parent folder\""; }
        { map = [ "index" "pager" ]; key = "H"; action = "view-raw-message"; }
        { map = [ "browser" ]; key = "l"; action = "select-entry"; }
        { map = [ "browser" ]; key = "gg"; action = "top-page"; }
        { map = [ "browser" ]; key = "G"; action = "bottom-page"; }
        { map = [ "pager" ]; key = "gg"; action = "top"; }
        { map = [ "pager" ]; key = "G"; action = "bottom"; }
        { map = [ "index" "pager" "browser" ]; key = "d"; action = "half-down"; }
        { map = [ "index" "pager" "browser" ]; key = "u"; action = "half-up"; }
        { map = [ "index" "pager" ]; key = "S"; action = "sync-mailbox"; }
        { map = [ "index" "pager" ]; key = "R"; action = "group-reply"; }
        { map = [ "index" ]; key = "\\031"; action = "previous-undeleted"; }
        { map = [ "index" ]; key = "\\005"; action = "next-undeleted"; }
        { map = [ "pager" ]; key = "\\031"; action = "previous-line"; }
        { map = [ "pager" ]; key = "\\005"; action = "next-line"; }
        { map = [ "editor" ]; key = "<Tab>"; action = "complete-query"; }
      ];
    };
    notmuch.enable = true;
  };

  # need to use setsid on video/* mpv
  xdg.configFile = {
    "neomutt/mailcap".text = let
      openurl = "${config.xdg.configHome}/neomutt/openurl";
    in ''
      text/plain; $EDITOR %s ;
      text/html; ${openurl} %s ; nametemplate=%s.html
      text/html; ${lib.getExe pkgs.lynx} -assume_charset=%{charset} -display_charset=utf-8 -dump -width=1024 %s; nametemplate=%s.html; copiousoutput;
      image/*; ${openurl} %s ;
      video/*; ${lib.getExe pkgs.mpv} --quiet %s &; copiousoutput
      audio/*; ${lib.getExe pkgs.mpv} %s ;
      application/pdf; ${openurl} %s ;
      application/pgp-encrypted; ${lib.getExe pkgs.gnupg} -d '%s'; copiousoutput;
      application/pgp-keys; ${lib.getExe pkgs.gnupg} --import '%s'; copiousoutput;
    '';
    "neomutt/openurl" = {
      source = ./neomutt/openurl;
      executable = true;
    };
  };
}
