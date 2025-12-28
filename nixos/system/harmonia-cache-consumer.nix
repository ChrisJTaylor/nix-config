{config, ...}: let
  publicKeyFileContents = config.sops.secrets.binary-cache-public-key;
in {
  nix.settings = {
    substituters = ["http://cache.machinology.local" "https://cache.nixos.org"];
    trusted-public-keys = [
      publicKeyFileContents
    ];
  };
}
