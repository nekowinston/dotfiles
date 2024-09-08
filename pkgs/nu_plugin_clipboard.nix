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
    sha256 = "sha256-N9UZJwM5aSWmFZaDAPUV7ZtgvuAPrbwrMKom3u4ok1E=";
    rev = "9db14a6b7ae1f080036ca8d9abf4c5fbf81dbeaa";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    AppKit
    IOKit
  ];

  cargoHash = "sha256-3WlmVH97kK5pJZSJiEvNTY/8X0Zhik4YIVtbReTriac=";

  meta = with lib; {
    description = "A nushell plugin to copy text into clipboard or get text from it.";
    license = licenses.mit;
    mainProgram = "nu_plugin_clipboard";
  };
}
