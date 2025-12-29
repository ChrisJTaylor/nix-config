{config, ...}: {
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.12.63"
  ];

  services.gnome.gnome-keyring.enable = true;

  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.sudo.enableGnomeKeyring = true;

  services.dbus.enable = true;

  # X11 and GNOME configuration (updated for NixOS 25.11)
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];

    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # GNOME and GDM services (new syntax for NixOS 25.11)
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = false; # X11 mode for legacy NVIDIA

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  hardware.nvidia.modesetting.enable = true;
}
