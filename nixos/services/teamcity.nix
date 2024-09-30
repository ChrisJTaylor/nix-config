{ ... }:

{
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    teamcity = {
      image = "jetbrains/teamcity-server:2024.07.2";
      autoStart = true;
      ports = [
        "127.0.0.1:8111:8111"
      ];
      volumes = [
        # "/mnt/apps/teamcity/conf:/opt/teamcity/conf:rw"
        # "/mnt/apps/teamcity/temp:/opt/teamcity/temp:rw"
        "/mnt/apps/teamcity/logs:/opt/teamcity/logs:rw"
        "/mnt/apps/teamcity_server/datadir:/data/teamcity_server/datadir:rw"
      ];
    };
  };
}
