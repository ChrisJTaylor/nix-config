{...}: {
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    installVimSyntax = true;

    settings = {
      shell-integration = "zsh";

      confirm-close-surface = false;

      custom-shader = "~/.ghostty-shaders/bloom.glsl";

      clipboard-read = "allow";
      clipboard-write = "allow";
      clipboard-trim-trailing-spaces = true;
      clipboard-paste-protection = true;

      background-opacity = 0.95;

      window-width = 160;
      window-height = 60;
      window-padding-x = 24;
      window-padding-y = 12;

      window-save-state = "always";

      resize-overlay = "always";

      keybind = [
        "alt+t=toggle_quick_terminal"
        "ctrl+b>f=toggle_fullscreen"
        "ctrl+b>d=toggle_window_decorations"
      ];

      font-family = "SauceCodePro NF";
      font-size = 14;
    };

    themes = {};
  };
}
