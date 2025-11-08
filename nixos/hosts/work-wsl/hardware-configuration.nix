# WSL-specific hardware configuration
{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/minimal.nix")
  ];

  # Set the platform for WSL
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # WSL-specific settings
  boot.isContainer = true;
  
  # WSL doesn't need a bootloader
  boot.loader.grub.enable = false;
  
  # WSL handles networking
  networking.dhcpcd.enable = false;
  networking.useDHCP = false;
  
  # Disable unnecessary services for WSL
  systemd.services.systemd-udev-trigger.enable = false;
  systemd.services.systemd-udevd.enable = false;
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "23.11";
}