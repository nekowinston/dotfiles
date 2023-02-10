{
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType1 rec {
  name = "cura";
  version = "5.2.1";

  src = fetchurl {
    url = "https://github.com/Ultimaker/Cura/releases/download/${version}/Ultimaker-Cura-${version}-linux-modern.AppImage";
    sha256 = "sha256-0RDKjmLv1efGR6/VN0Enx7jiuA9DCKboNoaVdHZGXTg=";
  };
}
