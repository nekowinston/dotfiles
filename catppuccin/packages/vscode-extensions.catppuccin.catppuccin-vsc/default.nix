{
  lib,
  vscode-utils,
  ...
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "catppuccin-vsc";
    publisher = "catppuccin";
    version = "2.5.0";
    sha256 = "sha256-+dM6MKIjzPdYoRe1DYJ08A+nHHlkTsm+I6CYmnmSRj4=";
  };
  meta = with lib; {
    description = "Soothing pastel theme for VSCode";
    license = licenses.mit;
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc";
    maintainers = with maintainers; [nekowinston];
  };
}
