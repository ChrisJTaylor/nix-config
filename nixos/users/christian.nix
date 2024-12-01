{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.christian = {
    useDefaultShell = true;
    isNormalUser = true;
    description = "Christian Taylor";
    home = "/home/christian";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" "plugdev" "podman" ];
    packages = with pkgs; [
    #  thunderbird
  ];
};
}
