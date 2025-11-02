{approved-packages, ...}: {
  # Global nixpkgs configuration
  nixpkgs.config.allowUnfree = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  fonts.packages = with approved-packages; [
    nerd-fonts-jetbrains-mono
    nerd-fonts-fira-code
    nerd-fonts-droid-sans-mono
    nerd-fonts-iosevka
    nerd-fonts-sauce-code-pro
  ];
}
