{ pkgs
, config
, ...
}: {
  sops.secrets.work_username.neededForUsers = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${config.sops.secrets.work_username.value} = {
    useDefaultShell = true;
    isNormalUser = true;
    description = "Christian Taylor";
    home = "/home/${config.sops.secrets.work_username.value}";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };
}
