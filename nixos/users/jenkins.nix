{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jenkins = {
    useDefaultShell = true;
    isSystemUser = true;
    description = "User account for Jenkins";
    extraGroups = [ "networkmanager" "wheel" "podman" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
}
