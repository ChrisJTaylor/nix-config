{approved-packages, ...}: {
  users.defaultUserShell = approved-packages.fish;

  programs = {
    fish = {
      enable = true;
    };
  };
}
