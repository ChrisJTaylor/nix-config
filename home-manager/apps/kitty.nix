{ ... }:

{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 12;
    };
    settings = {
      background_opacity = "0.8";
      background_blur = 32;
    };
  };
}
