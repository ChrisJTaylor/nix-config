{...}: {
  nix.settings = {
    substituters = [
      "http://cache.machinology.local"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      (builtins.readFile ../../none-secrets/binary-cache-public-key.pem)
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
}
