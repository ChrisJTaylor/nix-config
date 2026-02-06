{approved-packages, ...}: {
  environment.systemPackages = with approved-packages; [
    omnissa-horizon-client
  ];
}
