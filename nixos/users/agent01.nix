{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.agent01 = {
    usedefaultshell = true;
    isnormaluser = true;
    description = "build agent";
    home = "/home/agent01";
    shell = pkgs.zsh;
    extragroups = [ "networkmanager" "wheel" ];
    packages = [

    ];
  };
}
