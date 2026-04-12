{
  approved-packages,
  lib,
  ...
}: {
  programs.direnv = {
    enable = true;
    package = approved-packages.direnv.overrideAttrs (oldAttrs: {
      doCheck = false;
    });
    silent = true;
    loadInNixShell = true;
    nix-direnv = {
      enable = true;
      package = approved-packages.nix-direnv;
    };
  };
}
