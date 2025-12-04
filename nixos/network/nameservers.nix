{...}: {
  # NixOS-only nameserver configuration (Linux systems only)
  networking.nameservers = [
    "192.168.1.246" # UGreen NAS
    "192.168.1.254" # Router
    "1.1.1.1" # Cloudflare DNS
    "8.8.8.8" # Google DNS
  ];
}
