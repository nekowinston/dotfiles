{
  darwin,
  fetchFromGitHub,
  rustPlatform,
  lib,
  stdenv,
}:
let
  inherit (darwin.apple_sdk.frameworks) AppKit IOKit;
in
rustPlatform.buildRustPackage {
  name = "nu_plugin_clipboard";
  version = "0.96.0";

  src = fetchFromGitHub {
    owner = "FMotalleb";
    repo = "nu_plugin_clipboard";
    sha256 = "sha256-Uo9dd9D32Q1eBVPFG9dYBvsWvBcpuu6QuaVqs7bdZfM=";
    rev = "494018928fb72e5b19c4eb83f0390645fc839651";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    AppKit
    IOKit
  ];

  cargoHash = "sha256-wGKqQwPjBjrqJEmfe8L6Wz2tRYJsZ4PiY7AmRvxxABQ=";

  meta = with lib; {
    description = "A nushell plugin to copy text into clipboard or get text from it.";
    license = licenses.mit;
    mainProgram = "nu_plugin_clipboard";
  };
}
