{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.gnupg
    pkgs.pinentry-curses
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
