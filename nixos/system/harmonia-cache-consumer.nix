{config, ...}: {
  # Configure nix to use the harmonia cache as a substituter
  # Note: domain is hardcoded to 'machinology' - must match the harmonia server config

  nix.settings = {
    substituters = ["https://cache.${config.sops.secrets.domain_name.value}.tld"];
    trusted-public-keys = ["cache.${config.sops.secrets.domain_name.value}.tld-1:${config.sops.secrets.harmonia_public_key}"];
  };
}
