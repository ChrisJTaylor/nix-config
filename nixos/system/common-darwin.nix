{ ... }:

{
  nixpkgs.config.allowUnfree = true;
  security.pam.enableSudoTouchIdAuth = true;
}
