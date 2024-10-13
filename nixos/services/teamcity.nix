{ ... }:

let version = {
  teamcity = "2024.07.2";
  nevergreen = "7.0.0";
};
  in
{
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    teamcity = {
      image = "jetbrains/teamcity-server:${version.teamcity}";
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
    teamcityAgent01 = {
      image = "jetbrains/teamcity-agent:${version.teamcity}-linux-sudo";
      autoStart = true;
      volumes = [
        "/var/run/podman/podman.sock:/var/run/docker.sock:rw"
        "/mnt/apps/teamcity_agents/mach_01/conf:/data/teamcity_agent/conf:rw"
        "/mnt/apps/teamcity_agents/mach_01/work:/opt/buildagent/work:rw"
        "/mnt/apps/teamcity_agents/mach_01/temp:/opt/buildagent/temp:rw"
        "/mnt/apps/teamcity_agents/mach_01/tools:/opt/buildagent/tools:rw"
        "/mnt/apps/teamcity_agents/mach_01/plugins:/opt/buildagent/plugins:rw"
        "/mnt/apps/teamcity_agents/mach_01/system:/opt/buildagent/system:rw"
      ];
      dependsOn = [ "teamcity" ];
      environment = {
        AGENT_NAME = "mach-01";
        DOCKER_IN_DOCKER = "start";
        SERVER_URL = "http://teamcity:8111";
      };
      extraOptions = [
        "--privileged"
      ];
    };
    teamcityAgent02 = {
      image = "jetbrains/teamcity-agent:${version.teamcity}-linux-sudo";
      autoStart = true;
      volumes = [
        "/var/run/podman/podman.sock:/var/run/docker.sock:rw"
        "/mnt/apps/teamcity_agents/mach_02/conf:/data/teamcity_agent/conf:rw"
        "/mnt/apps/teamcity_agents/mach_02/work:/opt/buildagent/work:rw"
        "/mnt/apps/teamcity_agents/mach_02/temp:/opt/buildagent/temp:rw"
        "/mnt/apps/teamcity_agents/mach_02/tools:/opt/buildagent/tools:rw"
        "/mnt/apps/teamcity_agents/mach_02/plugins:/opt/buildagent/plugins:rw"
        "/mnt/apps/teamcity_agents/mach_02/system:/opt/buildagent/system:rw"
      ];
      dependsOn = [ "teamcity" ];
      environment = {
        AGENT_NAME = "mach-02";
        DOCKER_IN_DOCKER = "start";
        SERVER_URL = "http://teamcity:8111";
      };
      extraOptions = [
        "--privileged"
      ];
    };
    nevergreen = {
      image = "buildcanariesteam/nevergreen:${version.nevergreen}";
      autoStart = true;
      ports = [
        "127.0.0.1:5000:5000"
      ];
    };
  };
}
