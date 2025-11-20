{approved-packages, ...}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    newSession = true;
    terminal = "tmux-256color";
    shortcut = "b";
    keyMode = "vi";
    plugins = with approved-packages; [
      tmux-continuum
      fzf-tmux-url
      tmux-power-theme
      tmux-session-wizard
      tmux-fzf
      tmux-cpu
    ];
    extraConfig = ''
      set -g default-shell ${approved-packages.zsh}/bin/zsh
      
      # Enhanced color support for headless environments
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -ag terminal-overrides ",screen-256color:RGB"
      set -ag terminal-overrides ",tmux-256color:RGB"
      
      # Enable true color support
      set-option -sa terminal-overrides ',*:RGB'
      set-option -ga terminal-overrides ',*:Tc'
      
      # Better color theme for headless
      set -g @tmux_power_theme 'forest'
      
      # Enhanced status bar with better contrast
      set -g status-style 'bg=#2e3440,fg=#d8dee9'
      set -g status-left-style 'bg=#5e81ac,fg=#eceff4'
      set -g status-right-style 'bg=#88c0d0,fg=#2e3440'
      
      set -g @continuum-boot-options 'on'
      set -g status-right '#[fg=#2e3440,bg=#88c0d0] #{cpu_percentage}  %H:%M '
      run-shell ${approved-packages.tmux-cpu}/share/tmux-plugins/cpu/cpu.tmux

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
      
      # Better pane border colors
      set -g pane-border-style 'fg=#4c566a'
      set -g pane-active-border-style 'fg=#5e81ac'
      
      # Better window list colors
      set -g window-status-style 'fg=#81a1c1'
      set -g window-status-current-style 'fg=#88c0d0,bold'
    '';
  };
}