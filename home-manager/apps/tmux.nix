{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    newSession = true;
    plugins = [
      pkgs.tmuxPlugins.continuum
      pkgs.tmuxPlugins.fzf-tmux-url
      pkgs.tmuxPlugins.catppuccin
      pkgs.tmuxPlugins.session-wizard
      pkgs.tmuxPlugins.tmux-fzf
    ];
    extraConfig = ''
    set -g @continuum-boot-options 'on' 
    set -g status-right '#[fg=black,bg=color15] #{cpu_percentage}  %H:%M '
    run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
    '';
  };
}
