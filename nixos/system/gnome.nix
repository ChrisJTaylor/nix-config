{...}: {
  services.gnome.gnome-keyring.enable = true;

  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.sudo.enableGnomeKeyring = true;

  services.dbus.enable = true;

  services.desktopManager = {
    gnome.enable = true;
  };

  services.displayManager = {
    gdm.enable = true;
    gdm.wayland = true;
  };

  services.xserver = {
    enable = true;

    xkb = {
      layout = "us";
      variant = "";
    };
  };
}
