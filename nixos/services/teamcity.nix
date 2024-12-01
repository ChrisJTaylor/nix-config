{ config, lib, pkgs, ... }:

let version = {
  teamcity = "2024.07.3";
  nevergreen = "7.0.0";
};
  in
{
  systemd.services.allowX11Access = {
    description = "Allow systemd-nspawn containers access to X11";
    wantedBy = [ "default.target" ];
    script = ''
      export DISPLAY=":1"
      export PATH=$PATH:${pkgs.xorg.xhost}/bin
      ${pkgs.xorg.xhost}/bin/xhost +local:systemd
    '';
  };

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

  containers.mach-agent-01 = {
    autoStart = true;

    bindMounts = {
      "/tmp/.X11-unix" = {
        hostPath = "/tmp/.X11-unix";
        isReadOnly = true;
      };
      "/dev/dri" = {
        hostPath = "/dev/dri";
        isReadOnly = true;
      };
    };

    config = (import ./teamcity-agent-config.nix { 
      inherit config lib pkgs;
    } { 
      agent_name = "nixagent01"; 
      teamcity_server_url = "http://teamcity:8111";
    });
  };


  containers.mach-agent-02 = {
    autoStart = true;

    bindMounts = {
      "/tmp/.X11-unix" = {
        hostPath = "/tmp/.X11-unix";
        isReadOnly = true;
      };
      "/dev/dri" = {
        hostPath = "/dev/dri";
        isReadOnly = true;
      };
    };

    config = (import ./teamcity-agent-config.nix { 
      inherit config lib pkgs;
    } { 
      agent_name = "nixagent02"; 
      teamcity_server_url = "http://teamcity:8111";
    });
  };

  containers.mach-agent-03 = {
    autoStart = true;

    bindMounts = {
      "/tmp/.X11-unix" = {
        hostPath = "/tmp/.X11-unix";
        isReadOnly = true;
      };
      "/dev/dri" = {
        hostPath = "/dev/dri";
        isReadOnly = true;
      };
    };

    config = (import ./teamcity-agent-config.nix { 
      inherit config lib pkgs;
    } { 
      agent_name = "nixagent03"; 
      teamcity_server_url = "http://teamcity:8111";
    });
  };

}
