{ pkgs
, config
, ...
}: {
  imports = [
    ./zsh.nix
    ./git.nix
    ./tmux.nix
    ./gh.nix
    ./btop.nix
    ./lazygit.nix
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    hello
    aichat

    ranger

    bcompare

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    (pkgs.writeShellScriptBin "my-hello" ''
      echo "Hello, ${config.home.username}!"
    '')

    # wrapper for beyond compare
    (pkgs.writeShellScriptBin "bcompare" ''
      open -a "Beyond Compare" "$@"
    '')
  ];

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
