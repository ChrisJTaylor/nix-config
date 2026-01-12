{
  config,
  approved-packages,
  ...
}: {
  services.open-webui = {
    enable = true;
    package = approved-packages.open-webui_latest;

    port = 3000;

    environment = {
      OLLAMA_BASE_URL = "http://192.168.1.200:11434";
      ENABLE_OLLAMA_API_STREAM = "false";
    };

    stateDir = "/var/lib/open-webui";

    openFirewall = true;
  };

  services.nginx = {
    enable = true;

    virtualHosts."chat.machinology.internal" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_buffering off;
        '';
      };
    };
  };
}
