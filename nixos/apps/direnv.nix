{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    silent = true;
    loadInNixShell = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

}
