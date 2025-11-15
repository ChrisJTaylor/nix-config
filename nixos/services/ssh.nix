# configuration.nix
{...}: {
  # Enable SSH access
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  # Open firewall ports for nginx (harmonia cache) and SSH
  networking.firewall.allowedTCPPorts = [22 80 443];
}
