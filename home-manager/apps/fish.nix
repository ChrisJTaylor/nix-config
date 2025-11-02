{approved-packages, ...}: {
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "grc";
        src = approved-packages.fishPlugins.grc.src;
      }
      {
        name = "git";
        src = approved-packages.fishPlugins.plugin-git.src;
      }
      {
        name = "fzf";
        src = approved-packages.fishPlugins.fzf-fish.src;
      }
      {
        name = "autopair";
        src = approved-packages.fishPlugins.autopair.src;
      }
      {
        name = "sponge";
        src = approved-packages.fishPlugins.sponge.src;
      }
    ];
    shellAbbrs = {
      gst = "git status";
      gfc = "git add -A; git checkout -f";
      gcm = "git add -A; git commit";
      vim = "nvim";
      v = "nvim .";
      md = "mkdir";
      rd = "rmdir";
    };
    interactiveShellInit = ''
      eval "$(atuin init fish)"
      eval "$(zoxide init fish --cmd cd)"
    '';
  };
}
