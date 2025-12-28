{...}: {
  services.openssh = {
    enable = true;
  };

  users.users.nix-builder = {
    isNormalUser = true;
    extraGroups = ["nixbld"];
    openssh.authorizedKeys.keys = [
      # Public key for the remote build machine
      (builtins.readFile ../../none-secrets/machbook-nix-builder.pub)
    ];
  };

  nix.settings.trusted-users = ["nix-builder"];
}
