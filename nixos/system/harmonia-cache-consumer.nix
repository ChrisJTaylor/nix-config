{config, ...}: {
  # Configure nix to use the harmonia cache as a substituter
  # Note: domain is hardcoded to 'machinology' - must match the harmonia server config

   nix.settings = {
     substituters = ["https://cache.machinology.local"];
     trusted-public-keys = ["cache.machinology.local-1:${config.sops.placeholder.harmonia_public_key}"];
   };
}
