{ ... }:

{
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".config/ghostty/config".text = ''
      # The syntax is "key = value". The whitespace around the
      # equals doesn't matter.
      background = 282c34
      foreground = ffffff

      # Empty values reset the configuration to the default value
      font-family = 

      clipboard-read = allow
      clipboard-write = allow
      clipboard-trim-trailing-spaces = true
      clipboard-paste-protection = true

      background-opacity = 0.95

      window-width = 160
      window-height = 60

      window-save-state = always

      resize-overlay = always

      keybind = ctrl+c=copy_to_clipboard
      keybind = ctrl+v=paste_from_clipboard

      keybind = alt+t=toggle_quick_terminal

      keybind = ctrl+b>shift+k=new_split:up
      keybind = ctrl+b>shift+j=new_split:down
      keybind = ctrl+b>shift+h=new_split:left
      keybind = ctrl+b>shift+l=new_split:right

      keybind = ctrl+b>k=goto_split:top
      keybind = ctrl+b>j=new_split:bottom
      keybind = ctrl+b>h=new_split:left
      keybind = ctrl+b>l=new_split:right
      keybind = ctrl+b>p=new_split:previous
      keybind = ctrl+b>n=new_split:next
    '';
  };
}
