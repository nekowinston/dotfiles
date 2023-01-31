{ buildNpmPackage, lib, pkgs, ... }:

buildNpmPackage {
  pname = "nodePackages.emmet-ls";
  version = "0.3.1";

  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/emmet-ls/-/emmet-ls-0.3.1.tgz";
    sha512 = "sha512-SbNxxpLHnkaT/lA8CpOnnu1fH+VMzEAniAoyqQV+CGVJ9BYwHbaDlOPRckoJFK/6czWCQqDWax1Gk5Pa+HrNmA==";
  };

  npmDepsHash = "sha256-Qxt/9v5gL237q5QmCXCstXlLKO2dGb9PAHWN2Bh4pEI=";

  meta = with lib; {
    description = "Emmet language server";
    homepage = "https://github.com/aca/emmet-ls";
    license = licenses.mit;
    maintainers = [ maintainers.nekowinston ];
  };
}
