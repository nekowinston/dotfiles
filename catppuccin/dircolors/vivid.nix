{
  fetchFromGitHub,
  lib,
  pkgs,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "vivid";
  version = "9299aa4c843bb7ed757b47bb2449abbba3aed793";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "vivid";
    rev = version;
    sha256 = "sha256-gzl4ETkwnSuSKA0g7udOdFbnG1poXU/ZQyDJj/zqOV4=";
  };

  cargoSha256 = "sha256-fcH2gZr+ttldelWbYwsMUMy5ayrRTZwNsj2Jqhn1HTc=";

  meta = with lib; {
    description = "A themeable LS_COLORS generator with a rich filetype datebase";
    homepage = "https://github.com/sharkdp/vivid";
    license = licenses.asl20;
    maintainers = [maintainers.nekowinston];
  };
}
