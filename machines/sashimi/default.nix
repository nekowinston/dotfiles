{
  imports = [ ./brew.nix ];

  nix.settings.extra-platforms = [
    "aarch64-darwin"
    "x86_64-darwin"
  ];

  location = {
    latitude = 48.210033;
    longitude = 16.363449;
  };

  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "orb";
        sshUser = "nixos";
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
          "gccarch-armv8-a"
        ];
        systems = [
          "aarch64-linux"
          "x86_64-linux"
        ];
      }
    ];
  };
}
