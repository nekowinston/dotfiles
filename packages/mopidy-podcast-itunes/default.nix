{
  lib,
  python3Packages,
  mopidy,
  mopidy-podcast,
}:
python3Packages.buildPythonApplication rec {
  pname = "mopidy-podcast-itunes";
  version = "3.0.1";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-Podcast-iTunes";
    sha256 = "sha256-sxowRHUGiUr7dKoNKs4htFJccEaBqvyvzINmrZIZIds=";
  };

  propagatedBuildInputs = with python3Packages; [
    mopidy
    mopidy-podcast
    cachetools
    responses
    uritools
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/tkem/mopidy-podcast-itunes";
    description = "Mopidy extension for searching and browsing podcasts on the Apple iTunes Store.";
    license = licenses.asl20;
    maintainers = [maintainers.nekowinston];
  };
}
