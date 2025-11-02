# Harmonia cache service configuration
{
  inputs,
  config,
  lib,
  ...
}: {
  imports = [inputs.harmonia.nixosModules.harmonia];

  sops.secrets.harmonia_email.neededForUsers = true;

  services.harmonia-dev.cache.enable = true;
  # FIXME: generate a public/private key pair like this:
  # $ nix-store --generate-binary-cache-key cache.yourdomain.tld-1 /var/lib/secrets/harmonia.secret /var/lib/secrets/harmonia.pub
  services.harmonia-dev.cache.signKeyPaths = ["/var/lib/secrets/harmonia.secret"];

  security.acme.defaults.email = "${config.sops.placeholder.harmonia_email}";
  security.acme.acceptTerms = true;

  # Enable nginx and firewall ports
  networking.firewall.allowedTCPPorts = [443 80];

  services.nginx = {
    enable = lib.mkDefault true;
    recommendedTlsSettings = lib.mkDefault true;
  };
}
