{ ... }:

{
  environment.pathsToLink = [ "/share/zsh" ];

  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      zsh-autoenv.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "direnv"
          "fzf"
        ];
      };
    };
  };

}
