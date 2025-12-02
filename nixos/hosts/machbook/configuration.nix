{approved-packages, lib, pkgs, ...}: {
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  nix.enable = true;
  nix.package = approved-packages.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Ensure SOPS age key is available for decryption
  system.activationScripts.ensureSopsAgeKey = lib.stringAfter ["etc"] ''
    mkdir -p /etc/sops/age
    if [ ! -f /etc/sops/age/keys.txt ]; then
      if [ -f /Users/christiantaylor/.config/sops/age/keys.txt ]; then
        install -m 644 -o root -g wheel /Users/christiantaylor/.config/sops/age/keys.txt /etc/sops/age/keys.txt
        echo "Installed SOPS age key into /etc/sops/age/keys.txt"
      else
        echo "No SOPS age key found in /Users/christiantaylor/.config/sops/age/keys.txt"
      fi
    fi
  '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  
  # Use system certificate bundle for SSL verification (macOS path)
  nix.settings.ssl-cert-file = "/etc/ssl/cert.pem";
}
