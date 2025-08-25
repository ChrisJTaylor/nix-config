{ ... }: {
  # Nix garbage collection and optimization
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  
  nix.settings = {
    auto-optimise-store = true;
    # Keep build results for faster rebuilds
    keep-outputs = true;
    keep-derivations = true;
  };
  
  # Optional: Automatic system maintenance
  system.autoUpgrade = {
    enable = false; # Set to true for automatic updates
    dates = "04:00";
    allowReboot = false;
  };
}