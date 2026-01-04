{
  approved-packages,
  config,
  ...
}: {
  sops.secrets.password_christian.neededForUsers = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.christian = {
    useDefaultShell = true;
    isNormalUser = true;
    description = "Christian Taylor";
    home = "/home/christian";
    hashedPasswordFile = config.sops.secrets.password_christian.path;
    shell = approved-packages.zsh;
    extraGroups = ["networkmanager" "wheel" "docker" "plugdev" "podman"];
    packages = with approved-packages; [
      #  thunderbird
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQTnaIVB3/uNe00kL1Xe6sxRoC7BRM2sZHQ+fXMEDzy christian.taylor@machinology.com"
    ];
  };
}
