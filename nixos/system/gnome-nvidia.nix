{
  config,
  pkgs,
  ...
}: {
  # Critical: Blacklist nouveau to prevent driver conflicts that cause boot hangs
  boot.blacklistedKernelModules = ["nouveau"];

  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.12.63"
  ];

  # Essential kernel parameters for NVIDIA legacy drivers
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  # Critical: OpenGL support (updated for NixOS 25.11)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Complete NVIDIA configuration for legacy cards
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    modesetting.enable = true;
    open = false; # Legacy drivers don't support open source variant
    nvidiaSettings = true;

    # Power management helps with stability on older cards
    powerManagement.enable = true;
    powerManagement.finegrained = false;
  };

  # GNOME keyring services
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
}
