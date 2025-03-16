{ config, ... }:

{
  services.xserver = {
    enable = true;

    videoDrivers = [
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
