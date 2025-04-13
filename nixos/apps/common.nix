{pkgs, ...}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    fzf
    fd
    bat
    delta
    eza
    ripgrep
    zoxide
    yazi
    lolcat
    cowsay
    just
    watchman
    grc
    atuin
    systemd
    podman
    xorg.xhost
    uv
    ghostty
    vmware-horizon-client
    lazydocker
    sops
    age
    yubioath-flutter
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
