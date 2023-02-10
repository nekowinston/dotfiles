{
  buildGoModule,
  fetchFromGitHub,
  lib,
  pkgs,
  ...
}:
buildGoModule rec {
  pname = "helm-ls";
  version = "20220912";

  src = fetchFromGitHub {
    owner = "mrjosh";
    repo = "helm-ls";
    rev = "1552f4be6b43eb3fc6c61ce056f1d28f36650c62";
    sha256 = "sha256-YSK7PBsk/NXsM7bFg6ebqiYDH94vsK45vMpZtDJqLnk=";
  };

  vendorSha256 = "sha256-EqZlmOoQtC3Iuf0LG2PL0K2pluGqbyA6132lzgF4+ic=";

  meta = with lib; {
    description = "helm language server";
    homepage = "https://github.com/mrjosh/helm-ls";
    license = licenses.mit;
    maintainers = [maintainers.nekowinston];
  };
}
