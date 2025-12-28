{
  approved-packages,
  config,
  ...
}: {
  # Auto upgrade nix package and the daemon service.
  nix.enable = true;

  nix.package = approved-packages.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.hostName = "machbook"; # Define your hostname.

  sops.secrets.nix-builder-ssh-key = {
    sopsFile = ./secrets/machbook.yaml;
    mode = "0600";
    owner = "root";
    path = "/root/.ssh/nix-builder";
  };

  nix.buildMachines = [
    {
      hostName = "cache.machinology.local";
      sshKey = config.sops.secrets.nix-builder-ssh-key.path;
    }
  ];
}
