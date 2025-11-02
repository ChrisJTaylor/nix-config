{approved-packages, ...}: {
  environment.systemPackages = with approved-packages; [
    wineWowPackages.stable
    wineWowPackages.waylandFull
    winetricks
    mono
  ];
}
