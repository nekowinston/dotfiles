{
  gobject-introspection,
  gtk3,
  lib,
  python3Packages,
  wrapGAppsHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "discover-overlay";
  version = "0.6.3";

  src = python3Packages.fetchPypi {
    inherit version pname;
    sha256 = "sha256-77oCS/MEPiHSVmoSNk1rFu0XLQLqLRSqJlj7ijQMC4A=";
  };

  nativeBuildInputs = [wrapGAppsHook gobject-introspection];
  propagatedBuildInputs = with python3Packages; [gobject-introspection gtk3 pillow pygobject3 pyxdg requests setuptools websocket-client xlib];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/trigg/Discover";
    description = "Yet another discord overlay for linux";
    license = licenses.gpl3;
    maintainers = [maintainers.nekowinston];
  };
}
