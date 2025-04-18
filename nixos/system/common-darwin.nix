{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  
  security.pki.installCACerts = true;

  fonts.packages = [
    pkgs.font-awesome_5
  ];
}
