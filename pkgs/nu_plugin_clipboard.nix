{
  darwin,
  fetchFromGitHub,
  rustPlatform,
  lib,
  stdenv,
}:
let
  inherit (darwin.apple_sdk.frameworks) AppKit IOKit;
  version = "0.99.0";
in
rustPlatform.buildRustPackage rec {
  name = "nu_plugin_clipboard";
  inherit version;

  src = fetchFromGitHub {
    owner = "FMotalleb";
    repo = "nu_plugin_clipboard";
    sha256 = "sha256-YSUnr/uGBAuoD2TcK2PSCGt62Yu7lV9Hu28GeM9RIUc=";
    rev = "b5b0ab6e2d781dbc3a87ba69b678a9fda7d38500";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    AppKit
    IOKit
  ];

  cargoHash = "sha256-r0ToGl62RRnWN6S2pCS+/+I5EgzfnbUhXdiCXEEUHYY=";

  meta = with lib; {
    description = "A nushell plugin to copy text into clipboard or get text from it.";
    license = licenses.mit;
    mainProgram = "nu_plugin_clipboard";
  };
}
