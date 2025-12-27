{
  config,
  pkgs,
  ...
}: let
  # Public keys are meant to be public, so we'll extract it at build time
  # The private key stays encrypted in SOPS
  publicKeyFile = config.sops.secrets.binary-cache-public-key.path;
in {
  nix.settings = {
    substituters = ["http://cache.machinology.local" "https://cache.nixos.org"];
    # We need to hardcode the public key here since it can't be read from SOPS at eval time
    # TODO: Replace this with your actual public key value
    # You can get it by decrypting: SOPS_AGE_KEY_FILE=/etc/sops/age/keys.txt sops -d secrets/cache-keys.yaml
    trusted-public-keys = [
      # "cache.machinology.local:YOUR_PUBLIC_KEY_HERE"
    ];
  };
  
  # Make the public key available for reference if needed
  environment.etc."nix/cache-public-key.pem".source = publicKeyFile;
}
