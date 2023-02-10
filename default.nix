let
  nix-pre-commit-hooks =
    import (builtins.fetchTarball
      "https://github.com/cachix/pre-commit-hooks.nix/tarball/master");
in {
  pre-commit-check = nix-pre-commit-hooks.run {
    src = ./.;
    hooks = {
      alejandra.enable = true;
      editorconfig-checker.enable = true;
      deadnix.enable = true;
      shellcheck.enable = true;
      stylua.enable = true;
    };
    settings.deadnix = {
      noLambdaPatternNames = true;
      noLambdaArg = true;
    };
  };
}
