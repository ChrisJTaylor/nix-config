{osConfig, ...}: {
  home-manager.backupFileExtension = "bakk";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [
  ];
  home-manager.users.christian = {
    imports = [
      ./files/files.nix
      ./apps/apps.nix
      ./apps/xdg_workaround.nix
    ];

    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = "christian";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.11"; # Please read the comment before changing.

    home.sessionVariables = {
      EDITOR = "nvim";
      NIXPKGS_ALLOW_UNFREE = 1;
      HOSTNAME = osConfig.networking.hostName;
    };
  };
}
