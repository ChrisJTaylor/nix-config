{
  approved-packages,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./base-no-tmux.nix # CLI tools and configs without tmux
  ];

  # Headless-only packages
  home.packages = with approved-packages; [
    # Custom script
    (pkgs.writeShellScriptBin "my-hello" ''
      echo "Hello, ${config.home.username}!"
    '')
  ];
}
