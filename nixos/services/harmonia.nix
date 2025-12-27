# configuration.nix
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.harmonia.nixosModules.harmonia];

  services.harmonia = {
    enable = true;
    signKeyPaths = [config.sops.secrets.binary-cache-private-key.path];
  };

  # Configure the private key secret for harmonia
  sops.secrets.binary-cache-private-key = {
    owner = "harmonia";
    group = "harmonia";
  };

  # Ensure harmonia and christian users can access Nix store
  nix.settings.allowed-users = ["christian" "harmonia"];

  # All other nginx configuration remains the same as above
  networking.firewall.allowedTCPPorts = [443 80 5000];
}
