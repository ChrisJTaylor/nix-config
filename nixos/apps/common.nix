{approved-packages, ...}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with approved-packages; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    fzf
    fd
    bat
    delta
    eza
    ripgrep
    zoxide
    just
    watchman
    grc
    atuin
    xhost
    uv
    lazydocker
    sops
    age
    cocogitto
    opencode
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
