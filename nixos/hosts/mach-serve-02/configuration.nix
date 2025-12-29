# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{config, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "mach-serve-02"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable scheduled shutdown at 10 PM daily
  services.scheduledShutdown = {
    enable = true;
    time = "22:00";
    warningMinutes = 5;
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  sops.secrets.nix-builder-ssh-key = {
    sopsFile = ../../../secrets/mach-serve-02.yaml;
    mode = "0600";
    owner = "root";
    path = "/root/.ssh/nix-builder";
  };

  nix.remoteBuilder = {
    enable = true;
    sshKeyPath = config.sops.secrets.nix-builder-ssh-key.path;
  };
}
