{...}: {
  services.openssh = {
    enable = true;
  };

  users.users.nix-builder = {
    isNormalUser = true;
    extraGroups = ["nixbld"];
  };

  nix.settings.trusted-users = ["nix-builder"];
}
