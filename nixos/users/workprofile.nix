{
  approved-packages,
  config,
  ...
}: {
  sops.secrets.work_username.neededForUsers = true;
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.taylch = {
    useDefaultShell = true;
    isNormalUser = true;
    description = "Christian Taylor";
    home = "/home/taylch";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with approved-packages; [
      #  thunderbird
    ];
  };
}
