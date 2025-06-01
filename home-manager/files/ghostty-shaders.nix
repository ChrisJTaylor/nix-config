{ pkgs, ... }:
let
  fullRepo = pkgs.fetchFromGitHub {
    owner = "hackr-sh";
    repo = "ghostty-shaders";
    rev = "a17573fb254e618f92a75afe80faa31fd5e09d6f";
    sha256 = "sha256-p0speO5BtLZZwGeuRvBFETnHspDYg2r5Uiu0yeqj1iE=";
    # use nix-prefetch-github to get the sha256:
    # nix run nixpkgs#nix-prefetch-github -- \
    #    hackr-sh ghostty-shaders --rev a17573fb254e618f92a75afe80faa31fd5e09d6f
  };
in
{
  config = {
    home.file.".ghostty-shaders".source = fullRepo;
  };
}
