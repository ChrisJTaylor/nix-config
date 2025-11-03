{
  approved-packages,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./base.nix
    ./ghostty.nix
  ];

  # Linux-specific packages
  home.packages = with approved-packages; [
    cider
    wakatime
    ungoogled-chromium

    # Custom script
    (pkgs.writeShellScriptBin "my-hello" ''
      echo "Hello, ${config.home.username}!"
    '')
  ];
}
