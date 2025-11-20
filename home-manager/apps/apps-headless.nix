{
  approved-packages,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./base.nix  # CLI tools and configs
  ];

  # Headless-only packages
  home.packages = with approved-packages; [
    wakatime                # CLI utility
    
    # Custom script
    (pkgs.writeShellScriptBin "my-hello" ''
      echo "Hello, ${config.home.username}!"
    '')
  ];
}