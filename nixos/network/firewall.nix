{...}: {
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [80 81 443];
    };
  };
}
