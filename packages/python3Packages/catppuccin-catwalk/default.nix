{
  lib,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "catppuccin_catwalk";
  version = "0.4.0";

  src = python3Packages.fetchPypi {
    inherit version pname;
    sha256 = "sha256-5TAw5H3soxe9vLhfj1qs8uMr4ybrHlCj4zdsMzvPo6s=";
  };

  propagatedBuildInputs = with python3Packages; [
    pillow
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/catppuccin/toolbox";
    description = "Part of catppuccin/toolbox, to generate preview a single composite screenshot for the four flavours";
    license = licenses.mit;
    maintainers = [maintainers.nekowinston];
  };
}
