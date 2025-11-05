{
  approved-packages,
  pkgs,
  lib,
  ...
}: let
  isLinux = pkgs.stdenv.isLinux;
in {
  # Common packages across all environments
  home.packages = with approved-packages;
    [
      ranger
    ]
    ++ lib.optional isLinux approved-packages.bcompare;

  # Common imports for all home-manager configurations
  imports = [
    ./tmux.nix
    ./zsh.nix
    ./git.nix
    ./gh.nix
    ./btop.nix
    ./lazygit.nix
  ];

  # Session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  # Enable Home Manager
  programs.home-manager.enable = true;

  # Starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
