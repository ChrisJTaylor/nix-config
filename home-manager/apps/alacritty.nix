{ ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      shell = "zsh";
      window = {
        opacity = 0.6;
	dimensions = {
	  columns = 160;
	  lines = 60;
	};
	padding = {
	  x = 22;
	  y = 22;
	};
      };
      font = {
        normal = { 
	  family = "JetBrainsMono Nerd Font";
	  style = "Regular";
	};
      };
      terminal = {
        osc52 = "CopyPaste";
      };
      selection = {
        save_to_clipboard = true;
      };
      mouse = {
        hide_when_typing = true;
      };
    };
  };

}
