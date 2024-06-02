{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.gnupg
    pkgs.pinentry
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
  };

}
