{ pkgs, ... }:

{
  xdg.portal = {
    config.common.default = "*";
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
