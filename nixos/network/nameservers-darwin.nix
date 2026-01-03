{
  pkgs,
  lib,
  ...
}: {
  # Darwin DNS configuration
  # nix-darwin does not support automatic DNS configuration like NixOS
  #
  # To configure DNS manually on macOS, run:
  #
  # for service in $(networksetup -listallnetworkservices | tail +2); do
  #   [[ "$service" != "*" ]] && networksetup -setdnsservers "$service" 192.168.1.246 1.1.1.1 8.8.8.8
  # done
  #
  # Or configure via System Preferences > Network > Advanced > DNS:
  # - Primary: 192.168.1.246 (UGreen NAS)
  # - Secondary: 1.1.1.1 (Cloudflare)
  # - Tertiary: 8.8.8.8 (Google)
}
