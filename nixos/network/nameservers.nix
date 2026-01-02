{...}: {
  # Enable networking
  networking.networkmanager = {
    enable = true;
    dns = "none"; # Disable NetworkManager DNS management to use NixOS nameservers
  };

  # Ensure NixOS has full control over DNS resolution
  networking.useHostResolvConf = false;

  # NixOS-only nameserver configuration (Linux systems only)
  networking.nameservers = [
    "192.168.1.136" # mach-serve-01
  ];
}
