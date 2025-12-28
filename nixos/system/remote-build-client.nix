{...}: {
  nix.buildMachines = [
    {
      hostName = "cache.machinology.local";
      system = "x86_64-linux";
      sshUser = "nix-builder";
      sshKey = "/root/.ssh/nix-builder";
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
    }
  ];

  nix.distributedBuilds = true;

  nix.settings.builders-use-substitutes = true;
}
