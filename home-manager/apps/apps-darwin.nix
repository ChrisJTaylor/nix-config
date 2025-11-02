{
  approved-packages,
  config,
  ...
}: {
  imports = [
    ./base.nix
  ];

  # Darwin-specific packages and scripts
  home.packages = with approved-packages; [
    # Custom scripts
    (writeShellScriptBin "my-hello" ''
      echo "Hello, ${config.home.username}!"
    '')

    # Beyond Compare wrapper for macOS
    (writeShellScriptBin "bcompare" ''
      open -a "Beyond Compare" "$@"
    '')
  ];
}
