let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      git
      git-secret
      just
    ];
    shellHook = ''
      ${(import ./default.nix).pre-commit-check.shellHook}
    '';
  }
