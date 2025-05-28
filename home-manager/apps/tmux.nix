{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    newSession = true;
    terminal = "screen-256color";
    shortcut = "b";
    keyMode = "vi";
    plugins = [
      pkgs.tmuxPlugins.continuum
      pkgs.tmuxPlugins.fzf-tmux-url
      pkgs.tmuxPlugins.power-theme
      pkgs.tmuxPlugins.session-wizard
      pkgs.tmuxPlugins.tmux-fzf
    ];
    extraConfig = ''
      set -g default-shell ${pkgs.zsh}/bin/zsh

      set -g @continuum-boot-options 'on'
      set -g status-right '#[fg=black,bg=color15] #{cpu_percentage}  %H:%M '
      run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux-plugins

      set -g xterm-keys on

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      bind -n S-Up select-pane -U
      bind -n S-Down select-pane -D
      bind -n S-Left select-pane -L
      bind -n S-Right select-pane -R

      bind -n C-Up resize-pane -U 5
      bind -n C-Down resize-pane -D 5
      bind -n C-Left resize-pane -L 5
      bind -n C-Right resize-pane -R 5

      bind w select-pane -t :.+ # next window
    '';
  };
}
