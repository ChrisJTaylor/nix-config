{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "git"; src = pkgs.fishPlugins.plugin-git.src; }
      { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
    ];
  };
}
