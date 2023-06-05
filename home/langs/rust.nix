{
  config,
  pkgs,
  ...
}: let
  inherit (config.xdg) dataHome;
in {
  home = rec {
    packages = [
      pkgs.sccache
      pkgs.cargo-mommy
    ];
    sessionVariables = {
      CARGO_HOME = "${dataHome}/cargo";
      CARGO_REGISTRIES_CRATES_IO_PROTOCOL = "sparse";
      CARGO_UNSTABLE_SPARSE_REGISTRY = "true";
      CARGO_MOMMYS_LITTLE = "boy";
      CARGO_MOMMYS_PRONOUNS = "his";
      CARGO_MOMMYS_ROLES = "daddy";
      RUSTC_WRAPPER = "sccache";
      RUSTUP_HOME = "${dataHome}/rustup";
    };
    sessionPath = [
      "${sessionVariables.CARGO_HOME}/bin"
    ];
    shellAliases = {
      "cargo" = "cargo mommy";
    };
  };
}
