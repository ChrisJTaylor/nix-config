{approved-packages, ...}: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.christiantaylor = {
    description = "Christian Taylor";
    home = "/Users/christiantaylor";
    shell = approved-packages.zsh;
    packages = with approved-packages; [
    ];
  };

  system.primaryUser = "christiantaylor";

  # specify group id for user
  ids.gids.nixbld = 350;
}
