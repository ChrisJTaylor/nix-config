{ ... }:

{
  environment.pathsToLink = [ "/share/zsh" ];

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      enableFzfCompletion = true;
      enableFzfGit = true;
      enableFzfHistory = true;
      enableSyntaxHighlighting = true;
    };
  };

}
