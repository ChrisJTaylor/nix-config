{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  security.pki.installCACerts = true;

  fonts.packages = with pkgs.nerd-fonts; [
    jetbrains-mono
    fira-code
    droid-sans-mono
  ];
}
