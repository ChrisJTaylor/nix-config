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

      background-opacity = 0.95
    '';
  };
}
