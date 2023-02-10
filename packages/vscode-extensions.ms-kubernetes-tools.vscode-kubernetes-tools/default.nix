{
  lib,
  vscode-utils,
  ...
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-kubernetes-tools";
    publisher = "ms-kubernetes-tools";
    version = "1.3.11";
    sha256 = "sha256-I2ud9d4VtgiiIT0MeoaMThgjLYtSuftFVZHVJTMlJ8s=";
  };
  meta = with lib; {
    description = "Develop, deploy and debug Kubernetes applications";
    license = licenses.asl20;
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools";
    maintainers = with maintainers; [nekowinston];
  };
}
