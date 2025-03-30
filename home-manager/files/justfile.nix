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

    "justfile".text = ''
      # show all available tasks
      _default:
        @just --list

      # show all justfile templates
      [no-cd]
      show-all-templates:
        ls -a ~/_justfile_templates/

      # copy justfile template to target directory
      [no-cd]
      copy-template template_name target_directory:
        cp ~./_justfile_templates/{{template_name}} {{target_directory}}/_justfile_templates

      # enable direnv
      enable-direnv:
        echo "use nix" >> .envrc && direnv allow

      # enable direnv for flake
      enable-direnv-for-flake:
        echo "use flake" >> .envrc && direnv allow
    '';
  };

}
