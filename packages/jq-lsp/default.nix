{
  buildGoModule,
  fetchFromGitHub,
  lib,
  ...
}:
buildGoModule rec {
  pname = "jq-lsp";
  version = "20221220";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "jq-lsp";
    rev = "4aadc9e4bf54eb3c4e24ac9f780d23bd0a04d76a";
    sha256 = "sha256-Xq0y685omljMOlxxqD1Q193G+UF0Y3ot5SXAzCma3S0=";
  };

  vendorSha256 = "sha256-ppQ81uERHBgOr/bm/CoDSWcK+IqHwvcL6RFi0DgoLuw=";

  meta = with lib; {
    description = "jq language server";
    homepage = "https://github.com/wader/jq-lsp";
    license = licenses.mit;
    maintainers = [maintainers.nekowinston];
  };
}
