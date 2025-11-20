{ ... }: {
  imports = [
    ./apps-headless.nix  # CLI tools + utilities
    ./apps-gui.nix       # GUI applications
  ];
}
