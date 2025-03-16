{ config, ... }:

{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    installVimSyntax = true;

    settings = {
      shell-integration = "zsh";

      clipboard-read = "allow";
      clipboard-write = "allow";
      clipboard-trim-trailing-spaces = true;
      clipboard-paste-protection = true;

      background-opacity = 0.95;

      window-width = 160;
      window-height = 60;

      window-save-state = "always";

      resize-overlay = "always";

      custom-shader = "~/workarea/ghostty-shaders/bloom.glsl";

      keybind = [
        "alt+t=toggle_quick_terminal"
        "ctrl+b>f=toggle_fullscreen"
        "ctrl+b>d=toggle_window_decorations"
      ];
    };

    themes = {

    };
  };
}
