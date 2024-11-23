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

  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-agent-01" ]; 
    externalInterface = "br0";
  };

  containers = {

    agent01 = {
      extraFlags = [ "-U" ];
      ephemeral = false;
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0";
      localAddress = "10.0.100.2/8";
    
      config = { config, pkgs, lib, ...}: 
      {
        system.stateVersion = "24.11";

        services.avahi = {
          nssmdns4 = true; # Allows software to use Avahi to resolve.
          enable = true;
          publish = {
            enable = true;
            addresses = true;
            workstation = true;
          };
        };

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
          extraGroups = [ "wheel" ];
        };

        services.resolved.enable = true;
        services.postfix.enable = true;

        networking = {
          hostName = "agent-01";
          interfaces."eth0".useDHCP = true;
          useHostResolvConf = false;
          firewall.enable = false;
        };
      };
    };

  };

}
