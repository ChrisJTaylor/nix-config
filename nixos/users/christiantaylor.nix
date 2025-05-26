{pkgs, ...}: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.christiantaylor = {
    description = "Christian Taylor";
    home = "/Users/christiantaylor";
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  system.primaryUser = "christiantaylor";

  # specify group id for user
  ids.gids.nixbld = 350;
}
