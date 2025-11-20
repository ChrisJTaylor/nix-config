{
  approved-packages,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./ghostty.nix  # Terminal emulator (GUI)
  ];

  # GUI-specific packages  
  home.packages = with approved-packages; [
    cider                    # Music player (GUI)
    ungoogled-chromium      # Web browser (GUI)
  ];
}