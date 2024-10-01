{
  darwin,
  fetchFromGitHub,
  rustPlatform,
  nushell,
  lib,
  stdenv,
}:
let
  inherit (darwin.apple_sdk.frameworks) AppKit IOKit;
  inherit (nushell) version;
in
rustPlatform.buildRustPackage {
  name = "nu_plugin_clipboard";
  inherit version;

  src = fetchFromGitHub {
    owner = "FMotalleb";
    repo = "nu_plugin_clipboard";
    sha256 = "sha256-/Oc57JaRlKZppJ9ZEKbSHb/8kg1XqziIQhpBB2uBT7c=";
    rev = version;
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    AppKit
    IOKit
  ];

  cargoHash = "sha256-8hf8RV1LGgDW6hfOPi8aAauvZbl8p1DXrITWH35nlpk=";

  meta = with lib; {
    description = "A nushell plugin to copy text into clipboard or get text from it.";
    license = licenses.mit;
    mainProgram = "nu_plugin_clipboard";
  };
}
