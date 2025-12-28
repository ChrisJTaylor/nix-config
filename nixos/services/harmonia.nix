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
    };
  };
}
