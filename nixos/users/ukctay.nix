{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ukctay = {
    isNormalUser = true;
    description = "ukctay";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  wsl = {
    defaultUser = "ukctay";
  };
}
