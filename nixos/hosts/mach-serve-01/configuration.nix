# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.harmonia.nixosModules.harmonia
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "mach-serve-01"; # Define your hostname.
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable scheduled shutdown at 10 PM daily
  services.scheduledShutdown = {
    enable = true;
    time = "22:00";
    warningMinutes = 5;
  };

  # Enable Harmonia daemon for proper upload support
  services.harmonia-dev.daemon.enable = true;
  
  services.harmonia-dev.cache.enable = true;
  # FIXME: generate a public/private key pair like this:
  # $ nix-store --generate-binary-cache-key cache.yourdomain.tld-1 /var/lib/secrets/harmonia.secret /var/lib/secrets/harmonia.pub
  services.harmonia-dev.cache.signKeyPaths = ["/var/lib/secrets/harmonia.secret"];
  
  # Ensure harmonia user can access Nix store
  nix.settings.allowed-users = ["harmonia"];

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

  # Configure nginx for harmonia cache with self-signed HTTPS for local network
  # Self-signed certificates will be generated automatically on first boot
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    virtualHosts."cache.machinology.local" = {
      # Serve both HTTP (port 80) and HTTPS (port 443) for easier local testing.
      # HTTPS uses self-signed cert; remove HTTP + set onlySSL = true once all clients trust the cert.
      sslCertificate = "/etc/ssl/certs/cache.machinology.local.crt";
      sslCertificateKey = "/etc/ssl/private/cache.machinology.local.key";
      forceSSL = false;
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation and on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
