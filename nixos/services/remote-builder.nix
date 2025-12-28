{...}: {
  services.openssh = {
    enable = true;
  };

  users.users.nix-builder = {
    isNormalUser = true;
    extraGroups = ["nixbld"];
    openssh.authorizedKeys.keys = [
      # Public key for the remote build machine
      (builtins.readFile ../../none-secrets/big-machbook-nix-builder.pub)
      (builtins.readFile ../../none-secrets/big-mach-nix-builder.pub)
      (builtins.readFile ../../none-secrets/home-wsl-nix-builder.pub)
      (builtins.readFile ../../none-secrets/mach-serve-02-nix-builder.pub)
    ];
  };

  nix.settings.trusted-users = ["nix-builder"];
}
