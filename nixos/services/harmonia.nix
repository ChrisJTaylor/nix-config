# configuration.nix
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.harmonia.nixosModules.harmonia];

  services.harmonia-dev.cache.enable = true;
  # FIXME: generate a public/private key pair like this:
  # $ nix-store --generate-binary-cache-key cache.yourdomain.tld-1 /var/lib/secrets/harmonia.secret /var/lib/secrets/harmonia.pub
  services.harmonia-dev.cache.signKeyPaths = ["/var/lib/secrets/harmonia.secret"];

  security.acme.defaults.email = "${config.sops.placeholder.harmonia_email}";
  security.acme.acceptTerms = true;

  # All other nginx configuration remains the same as above
  networking.firewall.allowedTCPPorts = [443 80];

  # Auto-generate Harmonia signing key pair if missing (idempotent)
  system.activationScripts.generateHarmoniaKey = lib.stringAfter ["etc"] ''
    if [ ! -f /var/lib/secrets/harmonia.secret ]; then
      echo "[harmonia] Generating binary cache signing key (cache.machinology.local-1)";
      mkdir -p /var/lib/secrets
      ${pkgs.nix}/bin/nix-store --generate-binary-cache-key cache.machinology.local-1 /var/lib/secrets/harmonia.secret /var/lib/secrets/harmonia.pub
      chmod 600 /var/lib/secrets/harmonia.secret
      chmod 644 /var/lib/secrets/harmonia.pub
    fi
  '';

  # Generate self-signed certificate on first boot if it doesn't exist
  system.activationScripts.generateSelfsignedCert = lib.stringAfter ["etc"] ''
    mkdir -p /etc/ssl/certs /etc/ssl/private
    if [ ! -f /etc/ssl/certs/cache.machinology.local.crt ]; then
      ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/private/cache.machinology.local.key \
        -out /etc/ssl/certs/cache.machinology.local.crt -days 3650 -nodes \
        -subj "/CN=cache.machinology.local"
      chmod 644 /etc/ssl/private/cache.machinology.local.key
      chmod 644 /etc/ssl/certs/cache.machinology.local.crt
      chown root:nginx /etc/ssl/private/cache.machinology.local.key
      chown root:root /etc/ssl/certs/cache.machinology.local.crt
    fi
  '';

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    virtualHosts."cache.machinology.local" = {
      enableACME = true;
      forceSSL = true;
      locations."/".extraConfig = ''
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_redirect http:// https://;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
      '';
    };
  };
}
