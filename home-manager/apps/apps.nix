{ pkgs, config, ... }:

{
  imports =
    [ 
#      ./nixvim.nix
      ./alacritty.nix
      ./zsh.nix
    ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    pkgs.hello
    pkgs.aichat

    pkgs.alacritty
    pkgs.alacritty-theme
    pkgs.gnomeExtensions.toggle-alacritty

    pkgs.cider

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    (pkgs.writeShellScriptBin "my-hello" ''
      echo "Hello, ${config.home.username}!"
    '')
  ];

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.navi = {
    enable = true;
    enableZshIntegration = true;
  };

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
	  family = "FiraCode Nerd Font";
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
