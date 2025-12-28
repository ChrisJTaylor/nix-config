# configuration.nix
{
  inputs,
  config,
  ...
}: {
  imports = [inputs.harmonia.nixosModules.harmonia];

  services.harmonia = {
    enable = true;
    signKeyPaths = [config.sops.secrets.binary-cache-private-key.path];
    settings = {
      bind = "127.0.0.1:5000";
    };
  };

  # Configure the private key secret for harmonia
  sops.secrets.binary-cache-private-key = {
    owner = "harmonia";
    group = "harmonia";
  };

  # Ensure harmonia and christian users can access Nix store
  nix.settings.allowed-users = ["christian" "harmonia"];

  # All other nginx configuration remains the same as above
  networking.firewall.allowedTCPPorts = [22 80];

  services.nginx = {
    enable = true;
    virtualHosts."cache.machinology.local" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:5000";
      };
      # Add metrics endpoint proxy
      locations."/metrics" = {
        proxyPass = "http://127.0.0.1:5000/metrics";
        extraConfig = ''
          # Pass through original headers
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };
}
