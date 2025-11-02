{ config, ... }:

{
  services.gnome.gnome-keyring.enable = true;

  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.sudo.enableGnomeKeyring = true;

  services.dbus.enable = true;

  services.xserver = {
    enable = true;

    videoDrivers = [
      "nvidia"
    ];

    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = false;

    xkb = {
      layout = "us";
      variant = "";
    };
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  hardware.nvidia.modesetting.enable = true;
}
