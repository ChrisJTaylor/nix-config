{approved-packages, ...}: {
  programs.direnv = {
    enable = true;
    package = approved-packages.direnv;
    silent = true;
    loadInNixShell = true;
    nix-direnv = {
      enable = true;
      package = approved-packages.nix-direnv;
    };
  };
}
