{pkgs, ...}: let
  fullRepo = pkgs.fetchFromGitHub {
    owner = "junegunn";
    repo = "fzf-git.sh";
    rev = "6651e719da630cd8e6e00191af7f225f6d13a801";
    sha256 = "sha256-FgJ5eyGU5EXmecwdjbiV+/rnyRaSMi8BLYWayeYgCJw=";
  };
  # nix run nixpkgs#nix-prefetch-github -- junegunn fzf-git --rev 6651e719da630cd8e6e00191af7f225f6d13a801
in {
  config = {
    environment.etc."fzf-git" = {
      source = fullRepo;
    };
  };
}
