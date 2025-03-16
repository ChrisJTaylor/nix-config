{ config, ... }:

{
  services.xserver = {
    enable = true;

    videoDrivers = [
      "nvidia"
    ];

    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;

    xkb = {
      layout = "us";
      variant = "";
    };
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
}
