{ ... }:

{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    virtualHosts = {
      "ci.machinology.internal" = {
        serverAliases = [ "ci-static.machinology.internal" ];
        forceSSL = false;
        enableACME = false;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:8111/";
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;

              # Optional: Increase timeout for WebSocket connections
              proxy_read_timeout 3600s;
              proxy_send_timeout 3600s;
            '';
          };
        };
      };

      "builds.machinology.internal" = {
        serverAliases = [ "builds-static.machinology.internal" ];
        forceSSL = false;
        enableACME = false;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:5000/";
          };
        };
      };
    };
  };

}
