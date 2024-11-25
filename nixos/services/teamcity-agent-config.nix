{ config, lib, pkgs, ... }:
{ agent_name, teamcity_server_url }:
let
  setupScript = pkgs.writeShellScript "" ''
    set -e
    mkdir -p /opt/teamcity-agent
    chown -R teamcity-agent:teamcity-agent /opt/teamcity-agent
    chmod -R 750 /opt/teamcity-agent
    ${pkgs.curl}/bin/curl -o /tmp/buildAgent.zip ${teamcity_server_url}/update/buildAgent.zip
    ${pkgs.unzip}/bin/unzip -o /tmp/buildAgent.zip -d /opt/teamcity-agent

    sed -i "s|^serverUrl=.*|serverUrl=${teamcity_server_url}|" /opt/teamcity-agent/conf/buildAgent.properties
    sed -i "s|^name=.*|name=${agent_name}|" /opt/teamcity-agent/conf/buildAgent.properties
    '';
in
{
  config = {
    system.stateVersion = "24.11"; 

    systemd.services.teamcity-agent = {
      description = "TeamCity Build Agent Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "/opt/teamcity-agent/bin/agent.sh start";
        ExecStop = "/opt/teamcity-agent/bin/agent.sh stop";
        Restart = "on-failure";
        User = "teamcity-agent";
        WorkingDirectory = "/opt/teamcity-agent";
        ReadWritePaths = [
          "/opt/teamcity-agent"
        ];
        ProtectSystem = false;
        ProtectHome = false;
        Environment = "PATH=/run/current-system/sw/bin:/bin:/usr/bin";
      };
      environment = {
        AGENT_NAME = "${agent_name}";
        SERVER_URL = "${teamcity_server_url}";
      };
    };

    networking.extraHosts = ''
        127.0.0.1 localhost
        10.88.0.3 teamcity 
    '';

    users.groups.teamcity-agent = {};

    users.users.teamcity-agent = {
      isSystemUser = true;
      group = "teamcity-agent";
      description = "TeamCity Agent";
      home = "/home/teamcity-agent";
      extraGroups = [ "wheel" "docker" "podman" ];
    };

    environment.systemPackages = with pkgs; [
      git
      curl
      vim
      bash
      unzip
      jq
      just
    ];

    programs.java = {
      enable = true;
      package = pkgs.jdk17;
    };

    systemd.services.setup-teamcity-agent = {
      description = "Setup TeamCity Agent";
      before = [ "teamcity-agent.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${setupScript}";
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };

  };
}
