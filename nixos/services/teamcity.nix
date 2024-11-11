{ ... }:

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

  containers = {

    agent01 = {
      autoStart = true;
      config = { config, pkgs, ...}: 
      {
        system.stateVersion = "24.05";

        environment.systemPackages = with pkgs; [
          curl
          vim
        ]; 

        programs.java = {
          enable = true;
          package = pkgs.jetbrains.jdk;
        };

        users.groups.agents = {};

        users.users.agent = {
          isSystemUser = false;
          isNormalUser = true;
          description = "build agent";
          home = "/home/agent";
          group = "agents";
        };
      };
    };

  };

}
