{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixos = {
    useDefaultShell = true;
    isNormalUser = true;
    description = "nixos";
    home = "/home/nixos";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "podman" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
}
