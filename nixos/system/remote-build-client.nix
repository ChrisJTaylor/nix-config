{
  config,
  lib,
  ...
}: let
  cfg = config.nix.remoteBuilder;
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
        default = "mach-serve-01";
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

  config = lib.mkIf cfg.enable {
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
  };
}
