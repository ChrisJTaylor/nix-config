{config, ...}: {
  # Configure nix to use the harmonia cache as a substituter
  # Note: domain is hardcoded to 'machinology' - must match the harmonia server config

   nix.settings = {
     substituters = ["https://cache.machinology.local"];
     # Public key is hardcoded since it's not actually secret
     trusted-public-keys = ["cache.machinology.local-1:cache.machinology.tld-1:xGHfhN8W8feCMFoUebMVYbLap5GxwqYz/18TllP6DmY="];
   };
}
