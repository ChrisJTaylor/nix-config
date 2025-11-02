{approved-packages, ...}: {
  xdg.portal = {
    config.common.default = "*";
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with approved-packages; [
      xdg-desktop-portal-gtk
    ];
  };
}
