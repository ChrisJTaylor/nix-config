{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = [
      pkgs.tmuxPlugins.weather
      pkgs.tmuxPlugins.continuum
      pkgs.tmuxPlugins.fzf-tmux-url
      pkgs.tmuxPlugins.catppuccin
      pkgs.tmuxPlugins.session-wizard
    ];
    extraConfig = ''
    set-option -g status-right '#{weather}'
    set -g status-right '#[fg=black,bg=color15] #{cpu_percentage}  %H:%M '
    run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
    '';
  };
}
