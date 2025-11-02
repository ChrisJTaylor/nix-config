# configuration.nix
{
  inputs,
  config,
  ...
}: {
  imports = [inputs.harmonia.nixosModules.harmonia];

  sops.secrets.harmonia_email.neededForUsers = true;
  sops.secrets.domain_name.neededForUsers = true;

  services.harmonia-dev.cache.enable = true;
  # FIXME: generate a public/private key pair like this:
  # $ nix-store --generate-binary-cache-key cache.yourdomain.tld-1 /var/lib/secrets/harmonia.secret /var/lib/secrets/harmonia.pub
  services.harmonia-dev.cache.signKeyPaths = ["/var/lib/secrets/harmonia.secret"];

  security.acme.defaults.email = "${config.sops.secrets.harmonia_email.value}";
  security.acme.acceptTerms = true;

  # All other nginx configuration remains the same as above
  networking.firewall.allowedTCPPorts = [443 80];

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    virtualHosts."cache.${config.sops.secrets.domain_name.value}.tld" = {
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
