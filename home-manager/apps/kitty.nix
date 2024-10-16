{ ... }:

{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    shellIntegration.enableFishIntegration = true;
    font = {
      name = "SourceCodePro Nerd Font";
      size = 10;
    };
    settings = {
      background_opacity = "0.8";
      background_blur = 32;
    };
    keybindings = {
      "ctrl+c" = "copy_to_clipboard";
      "ctrl+v" = "paste_from_clipboard";
    };
  };
}
