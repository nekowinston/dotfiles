{
  imports = [ ./brew.nix ];

  location = {
    latitude = 48.210033;
    longitude = 16.363449;
  };

  nix = {
    settings.extra-platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    settings.builders-use-substitutes = true;
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "orb";
        sshUser = "nixos";
        protocol = "ssh-ng";

        mandatoryFeatures = [ ];
        maxJobs = 1;
        speedFactor = 1;
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
