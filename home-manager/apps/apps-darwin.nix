{
  approved-packages,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./base.nix
  ];

  # Darwin-specific packages and scripts
  home.packages = with approved-packages; [
    # Custom scripts
    (pkgs.writeShellScriptBin "my-hello" ''
      echo "Hello, ${config.home.username}!"
    '')
  ];
}
