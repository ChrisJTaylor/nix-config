{
  config,
  lib,
  approved-packages,
  ...
}: let
  versions = import ./versions.nix;
in {
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    teamcity = {
      image = "jetbrains/teamcity-server:${versions.teamcity}";
      autoStart = true;
      ports = [
        "127.0.0.1:8111:8111"
      ];
      volumes = [
        "/mnt/apps/teamcity/conf:/opt/teamcity/conf:rw"
        "/mnt/apps/teamcity/logs:/opt/teamcity/logs:rw"
        "/mnt/apps/teamcity_server/datadir:/data/teamcity_server/datadir:rw"
      ];
    };

    nevergreen = {
      image = "buildcanariesteam/nevergreen:${versions.nevergreen}";
      autoStart = true;
      ports = [
        "127.0.0.1:5000:5000"
      ];
    };
  };

  containers.mach-agent-01 = {
    autoStart = true;

    config =
      import ./teamcity-agent-config.nix
      {
        inherit config lib approved-packages;
      }
      {
        agent_name = "nixagent01";
        teamcity_server_url = "http://teamcity:8111";
      };
  };

  containers.mach-agent-02 = {
    autoStart = true;

    config =
      import ./teamcity-agent-config.nix
      {
        inherit config lib approved-packages;
      }
      {
        agent_name = "nixagent02";
        teamcity_server_url = "http://teamcity:8111";
      };
  };

  containers.mach-agent-03 = {
    autoStart = true;

    config =
      import ./teamcity-agent-config.nix
      {
        inherit config lib approved-packages;
      }
      {
        agent_name = "nixagent03";
        teamcity_server_url = "http://teamcity:8111";
      };
  };
}
