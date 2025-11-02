{approved-packages, ...}: {
  environment.systemPackages = with approved-packages; [
    discord
  ];
}
