{approved-packages, ...}: {
  services.openssh = {
    enable = true;
  };

  users.users.nix-builder = {
    isSystemUser = true;
    group = "remotebuild";
    useDefaultShell = true;

    openssh.authorizedKeys.keys = [
      # Public key for the remote build machine
      (builtins.readFile ../../none-secrets/big-machbook-nix-builder.pub)
      (builtins.readFile ../../none-secrets/big-mach-nix-builder.pub)
      (builtins.readFile ../../none-secrets/home-wsl-nix-builder.pub)
      (builtins.readFile ../../none-secrets/mach-serve-02-nix-builder.pub)
      (builtins.readFile ../../none-secrets/think-mach-nix-builder.pub)
    ];
  };

  users.groups.remotebuild = {};

  nix.settings.trusted-users = ["nix-builder"];
}
