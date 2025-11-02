{
  inputs,
  approved-packages,
  ...
}: {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${approved-packages.system}.hyprland;
  };
}
