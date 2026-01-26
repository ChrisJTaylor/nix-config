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
        default = "mach-serve-01.lan";
      };

      system = lib.mkOption {
        type = lib.types.str;
        description = "System architecture of remote builder";
        default = "x86_64-linux";
      };

      maxJobs = lib.mkOption {
        type = lib.types.int;
        description = "Maximum number of concurrent jobs";
        default = 3;
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
          hostName =
            if lib.hasPrefix "ssh://" cfg.hostName || lib.hasPrefix "ssh-ng://" cfg.hostName
            then cfg.hostName
            else "nix-builder@${cfg.hostName}";
          system = cfg.system;
          sshKey = cfg.sshKeyPath;
          protocol = "ssh-ng";
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
      # Ensure /root/.ssh directory exists before SOPS tries to create the key
      system.activationScripts.createRootSshDir = {
        text = ''
          mkdir -p /root/.ssh
          chmod 700 /root/.ssh
        '';
        deps = [];
      };

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
