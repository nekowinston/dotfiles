let pkgs = import <nixpkgs> {}; in

pkgs.mkShell {
  buildInputs = with pkgs; [
    git
    git-secret
    just
  ];
}
