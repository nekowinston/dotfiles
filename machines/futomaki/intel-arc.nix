{ pkgs, ... }:
{
  boot.initrd.kernelModules = [ "i915" ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";
  };
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver # modern VAAPI for Arc
        libvdpau-va-gl # support VDPAU via VAAPI
        vpl-gpu-rt
      ];
    };
    intel-gpu-tools.enable = true;
  };
}
