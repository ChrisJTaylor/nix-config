{
  config,
  lib,
  ...
}: let
  cfg = config.nix.remoteBuilder;
  hostName = config.networking.hostName;

  # Map hostnames to their corresponding secrets files
  secretsFileMap = {
    "big-mach" = ../../secrets/big-mach.yaml;
    "big-machbook" = ../../secrets/big-machbook.yaml;
    "think-mach" = ../../secrets/think-mach.yaml;
    "home-wsl" = ../../secrets/home-wsl.yaml;
    "mach-serve-02" = ../../secrets/mach-serve-02.yaml;
  };

  hasSecretsFile = builtins.hasAttr hostName secretsFileMap;
  secretsFile = secretsFileMap.${hostName} or null;
in {
  options = {
    nix.remoteBuilder = {
      enable = lib.mkEnableOption "remote build client";

      sshKeyPath = lib.mkOption {
        type = lib.types.str;
        description = "Path to SSH key for remote builder";
        default = "/root/.ssh/nix-builder";
      };

      hostName = lib.mkOption {
        type = lib.types.str;
        description = "Hostname of the remote builder";
        default = "cache.machinology.local";
      };

      system = lib.mkOption {
        type = lib.types.str;
        description = "System architecture of remote builder";
        default = "x86_64-linux";
      };

      maxJobs = lib.mkOption {
        type = lib.types.int;
        description = "Maximum number of concurrent jobs";
        default = 4;
      };

      speedFactor = lib.mkOption {
        type = lib.types.int;
        description = "Speed factor relative to local machine";
        default = 2;
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      nix.buildMachines = [
        {
          hostName = cfg.hostName;
          system = cfg.system;
          sshUser = "nix-builder";
          sshKey = cfg.sshKeyPath;
          maxJobs = cfg.maxJobs;
          speedFactor = cfg.speedFactor;
          supportedFeatures = ["benchmark" "big-parallel"];
        }
      ];

      nix.distributedBuilds = true;
      nix.settings.builders-use-substitutes = true;
    })

    # Configure SSH key secret if this host has a corresponding secrets file
    (lib.mkIf (cfg.enable && hasSecretsFile) {
      sops.secrets.nix-builder-ssh-key = {
        sopsFile = secretsFile;
        path = cfg.sshKeyPath;
        owner = "root";
        group = "root";
        mode = "0600";
      };
    })
  ];
}
