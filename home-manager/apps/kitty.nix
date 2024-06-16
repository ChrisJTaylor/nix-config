{ ... }:

{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    font = {
      name = "SourceCodePro Nerd Font";
      size = 10;
    };
    settings = {
      background_opacity = "0.8";
      background_blur = 32;
    };
  };
}
