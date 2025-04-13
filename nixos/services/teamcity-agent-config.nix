{
  config,
  lib,
  pkgs,
  ...
}: {
  agent_name,
  teamcity_server_url,
  additionalPackages ? [],
}: let
  setupScript = pkgs.writeShellScript "" ''
    set -e

    FLAG_FILE="/opt/teamcity-agent/.setup-complete"
    if [ -f "$FLAG_FILE" ]; then
      echo "Teamcity Agent already installed."
      exit 0
    fi

    echo "Begin setup for Teamcity Agent..."
    mkdir -p /opt/teamcity-agent
    ${pkgs.curl}/bin/curl -o /tmp/buildAgent.zip ${teamcity_server_url}/update/buildAgent.zip
    ${pkgs.unzip}/bin/unzip -o /tmp/buildAgent.zip -d /opt/teamcity-agent
    chown -R teamcity-agent:teamcity-agent /opt/teamcity-agent
    chmod -R 750 /opt/teamcity-agent

    sed -i "s|^serverUrl=.*|serverUrl=${teamcity_server_url}|" /opt/teamcity-agent/conf/buildAgent.properties
    sed -i "s|^name=.*|name=${agent_name}|" /opt/teamcity-agent/conf/buildAgent.properties

    touch "$FLAG_FILE"
    chown teamcity-agent:teamcity-agent "$FLAG_FILE"

    echo "Completed setup for Teamcity Agent."
  '';
in {
  config = {
    system.stateVersion = "24.11";

    systemd.services.teamcity-agent = {
      description = "TeamCity Build Agent Service";
      after = ["network.target"];

      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "oneshot";

        User = "teamcity-agent";
        Group = "teamcity-agent";
        ExecStart = "/run/current-system/sw/bin/bash /opt/teamcity-agent/bin/agent.sh start";
        ExecStop = "/run/current-system/sw/bin/bash /opt/teamcity-agent/bin/agent.sh stop";

        RemainAfterExit = true;
        SuccessExitStatus = [0 143];
        WorkingDirectory = "/opt/teamcity-agent";
        ReadWritePaths = [
          "/opt/teamcity-agent"
          "/opt/teamcity-agent/logs"
          "/opt/teamcity-agent/conf"
        ];
        ProtectSystem = false;
        ProtectHome = false;
        PrivateTmp = false;
        LogLevelMax = "debug";
        Environment = ''
          PATH="/run/current-system/sw/bin:/bin:/usr/bin"
          JAVA_HOME="/run/current-system/sw/bin/jdk21"
        '';
      };
    };

    networking.extraHosts = ''
      127.0.0.1 localhost
      10.88.0.3 teamcity
    '';

    users.groups.teamcity-agent = {};

    users.users.teamcity-agent = {
      isNormalUser = true;
      group = "teamcity-agent";
      description = "TeamCity Agent";
      home = "/home/teamcity-agent";
      extraGroups = ["networkmanager" "wheel" "docker" "plugdev" "podman"];
    };

    environment.systemPackages = with pkgs;
      [
        git
        curl
        vim
        bash
        unzip
        jq
        just
      ]
      ++ additionalPackages;

    programs.java = {
      enable = true;
      package = pkgs.jdk21;
    };

    systemd.services.setup-teamcity-agent = {
      description = "Setup TeamCity Agent";
      before = ["teamcity-agent.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${setupScript}";
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };
}
