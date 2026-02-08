{
  approved-packages,
  config,
  ...
}: let
  username = "christian";
  description = "Christian Taylor";
  auth_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQTnaIVB3/uNe00kL1Xe6sxRoC7BRM2sZHQ+fXMEDzy christian.taylor@machinology.com";
in {
  imports = [
    ../k8s/kubectl-client.nix
  ];

  sops.secrets."password_${username}".neededForUsers = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.christian = {
    useDefaultShell = true;
    isNormalUser = true;
    description = description;
    home = "/home/${username}";
    hashedPasswordFile = config.sops.secrets."password_${username}".path;
    shell = approved-packages.zsh;
    extraGroups = ["networkmanager" "wheel" "docker" "plugdev" "podman"];
    packages = with approved-packages; [
      #  thunderbird
    ];
    openssh.authorizedKeys.keys = [auth_key];
  };

  services.k3s-kubeconfig = {
    enable = true;
    username = username;
  };
}
