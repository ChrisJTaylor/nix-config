{ pkgs, config, ... }: {
  imports = [
    ./base.nix
    ./ghostty.nix
  ];

  # Linux-specific packages
  home.packages = with pkgs; [
    cider
    wakatime
    ungoogled-chromium

    # Custom script
    (writeShellScriptBin "my-hello" ''
      echo "Hello, ${config.home.username}!"
    '')
  ];
}
