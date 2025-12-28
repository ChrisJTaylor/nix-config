{config, ...}: let
  publicKeyFileContents = config.sops.secrets.binary-cache-public-key.contents;
in {
  nix.settings = {
    substituters = ["http://cache.machinology.local" "https://cache.nixos.org"];
    trusted-public-keys = [
      "cache.machinology.local:${publicKeyFileContents}"
    ];
  };
