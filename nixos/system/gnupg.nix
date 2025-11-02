{approved-packages, ...}: {
  environment.systemPackages = [
    approved-packages.gnupg
    approved-packages.pinentry-curses
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = approved-packages.pinentry-curses;
  };
}
