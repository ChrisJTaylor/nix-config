{ pkgs, config, ... }: {
  imports = [
    ./base.nix
  ];

  # Darwin-specific packages and scripts
  home.packages = with pkgs; [
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
