{approved-packages, ...}: {
  # Note: observatory package needs to be defined or found in nixpkgs
  # systemd.packages = with approved-packages; [
  #   observatory
  # ];

  # systemd.services.monitord.wantedBy = ["multi-user.target"];
}
