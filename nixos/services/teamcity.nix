{ pkgs, ... }:

let version = {
  teamcity = "2024.07.3";
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

    nevergreen = {
      image = "buildcanariesteam/nevergreen:${version.nevergreen}";
      autoStart = true;
      ports = [
        "127.0.0.1:5000:5000"
      ];
    };

  };

  containers.teamcity-agent = {
    autoStart = true;
    config = {
      system.stateVersion = "24.11"; # Replace with your NixOS version

      environment.variables = {
        TEAMCITY_AGENT_OPTS = "-Dsome.option=value";
        TEAMCITY_SERVER_URL = "http://teamcity:8111";
      };

      networking.extraHosts = ''
        127.0.0.1 localhost
        10.88.0.1 teamcity 
      '';

      users.groups.teamcity-agents = {};

      users.users.teamcity-agent = {
        isSystemUser = true;
        group = "teamcity-agents";
      };

      environment.systemPackages = with pkgs; [
        git
        openjdk
        curl
        vim
      ];
    };
  };

}
