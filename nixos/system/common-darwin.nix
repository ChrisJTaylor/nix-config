{approved-packages, ...}: {
  nixpkgs.config.allowUnfree = true;

  security.pki.installCACerts = true;

  fonts.packages = with approved-packages.nerd-fonts; [
    jetbrains-mono
    fira-code
    droid-sans-mono
  ];
}
