{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in {
  imports = [
    ./apps/browsers.nix
    ./apps/fonts.nix
    ./apps/git.nix
    ./apps/gpg.nix
    ./apps/kubernetes.nix
    ./apps/mail.nix
    ./apps/media.nix
    ./apps/neovim.nix
    ./apps/newsboat.nix
    ./apps/rice.nix
    ./apps/sway.nix
    ./apps/vscode.nix
    ./apps/wezterm.nix
    ./apps/zsh.nix
    ./langs
    ./secrets/sops.nix
    ./xdg.nix
  ];

  home = {
    packages = with pkgs; ([
        _1password
        age
        fd
        ffmpeg
        file
        gh
        git-crypt
        gocryptfs
        imagemagick
        just
        mdcat
        mosh
        ranger
        ripgrep
        sops
      ]
      ++ lib.optionals isLinux [
        _1password-gui
        kooha
        jetbrains.goland
        jetbrains.webstorm
      ]);
    sessionVariables = lib.mkIf isDarwin {
      SSH_AUTH_SOCK = "${config.programs.gpg.homedir}/S.gpg-agent.ssh";
    };
    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
    man.enable = true;
    taskwarrior.enable = true;
  };

  home.activation.set-wallpaper = let
    wallpaper = ./wallpapers/dhm_1610.png;
    killall = lib.getExe pkgs.killall;
    sqlite = lib.getExe pkgs.sqlite;
  in
    lib.mkIf isDarwin (lib.hm.dag.entryAfter ["writeBoundary"] ''
      dpdb="$HOME/Library/Application Support/Dock/desktoppicture.db"

      ${sqlite} "$dpdb" "insert into data values ('${wallpaper}');"
      new_entry=$(${sqlite} "$dpdb" "select max(rowid) from data;")
      pics=$(${sqlite} "$dpdb" "select rowid from pictures")

      ${sqlite} "$dpdb" "delete from preferences;"

      for pic in $pics; do
        ${sqlite} "$dpdb" "insert into preferences (key, data_id, picture_id) values(1, $new_entry, $pic)"
      done

      ${killall} Dock
    '');

  xdg.configFile."ideavim/ideavimrc".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/ideavim/ideavimrc";
  xdg.configFile."Yubico/u2f_keys".text = ''
    winston:+SzANNyl5RpjNZFCthItSi7rQgiNqKNQztm2omNDnMOMNYXbnpoxMY/tqNCqoUtcAnkSmfC1/2E3WMZZ+IupFw==,gw1FnUrGJ2/vsxrcyOP17603yWSSk2OaatqvqkzhiEmRd/FAzWuXYE2YA16SBB9n+f6IypjerPgwY06zOw3DOA==,es256,+presence%
  '';
}
