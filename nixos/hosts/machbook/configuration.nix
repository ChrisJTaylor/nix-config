{approved-packages, ...}: {
  # Auto upgrade nix package and the daemon service.
  nix.enable = true;

  nix.package = approved-packages.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
