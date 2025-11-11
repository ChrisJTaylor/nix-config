{
  config,
  lib,
  ...
}: let
  # Check if both sops.secrets and the specific secret exist
  hasSopsSecrets = config.sops ? secrets;
  hasHarmoniaSecret = hasSopsSecrets && (config.sops.secrets ? harmonia_public_key);
  hasHarmoniaPlaceholder = hasSopsSecrets && (config.sops ? placeholder) && (config.sops.placeholder ? harmonia_public_key);

  # Use SOPS placeholder only if all conditions are met
  harmoniaPublicKey =
    if hasHarmoniaPlaceholder
    then config.sops.placeholder.harmonia_public_key
    else "xGHfhN8W8feCMFoUebMVYbLap5GxwqYz/18TllP6DmY=";
in {
  # Configure nix to use the harmonia cache as a substituter
  # Note: domain is hardcoded to 'machinology' - must match the harmonia server config

  nix.settings = {
    substituters = ["http://cache.machinology.lan"];
    # Public key from SOPS secret when available, fallback to hardcoded key
    trusted-public-keys = ["cache.machinology.lan-1:${harmoniaPublicKey}"];
  };
}
