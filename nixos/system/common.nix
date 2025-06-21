{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  fonts.packages = with pkgs.nerd-fonts; [
    jetbrains-mono
    fira-code
    droid-sans-mono
    iosevka
    sauce-code-pro
  ];
}
