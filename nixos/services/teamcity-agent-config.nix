{ pkgs, ... }:
{
  config = {
    system.stateVersion = "24.11"; # Replace with your NixOS version

    environment.variables = {
      TEAMCITY_AGENT_OPTS = "-Dsome.option=value";
      TEAMCITY_SERVER_URL = "http://teamcity:8111";
    };

    networking.extraHosts = ''
        127.0.0.1 localhost
        10.88.0.3 teamcity 
    '';

    users.groups.teamcity-agents = {};

    users.users.teamcity-agent = {
      isSystemUser = true;
      group = "teamcity-agents";
    };

    environment.systemPackages = with pkgs; [
      git
      curl
      vim
    ];

    programs.java = {
      enable = true;
      package = pkgs.jdk17;
    };
  };
}
