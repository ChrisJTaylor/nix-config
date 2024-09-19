{ pkgs, ... }:

{
  environment.pathsToLink = ["/share/zsh"];

  programs = {
     zsh = {
        enable = true;
        enableCompletion = true;
     };
  };

}
