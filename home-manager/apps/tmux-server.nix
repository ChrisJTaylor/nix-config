{approved-packages, ...}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    newSession = true;
    terminal = "tmux-256color"; # Enhanced color support
    shortcut = "b";
    keyMode = "vi";
    plugins = with approved-packages; [
      tmux-resurrect
      tmux-continuum
      fzf-tmux-url
      tmux-power-theme
      tmux-session-wizard
      tmux-fzf
      # Removed tmux-cpu - using manual calculation to eliminate duplication
    ];
    extraConfig = ''
      set -g default-shell ${approved-packages.zsh}/bin/zsh

      # ===== CYBERPUNK SPACE THEME - SERVER OPTIMIZED (SIMPLIFIED & WORKING) =====

      # Enhanced color support for headless environments
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -ag terminal-overrides ",screen-256color:RGB"
      set -ag terminal-overrides ",tmux-256color:RGB"

      # Enable true color support
      set-option -sa terminal-overrides ',*:RGB'
      set-option -ga terminal-overrides ',*:Tc'

      # Status bar configuration
      set -g status-position top
      set -g status-interval 5
      set -g status-justify left

      # Plugin base configuration
      set -g @continuum-boot-options 'on'

      # Brighter cyberpunk space theme for server/SSH visibility
      set -g @tmux_power_theme '#0f1419'
      set -g @tmux_power_g0 "#0f1419"    # Brighter deep space
      set -g @tmux_power_g1 "#1f1f3a"    # Brighter space purple
      set -g @tmux_power_g2 "#394758"    # Brighter border inactive
      set -g @tmux_power_g3 "#00e6ff"    # Brighter neon cyan
      set -g @tmux_power_g4 "#ff0080"    # Brighter neon magenta

      # Force override status bar styling with enhanced contrast
      set -g status-style "bg=#0f1419,fg=#ffffff"

      # Status bar length management
      set -g status-left-length 50
      set -g status-right-length 150

      # Left status: Session with prefix indicator (ULTRA SIMPLIFIED FOR DEBUG)
      set -g status-left '#[bg=#00e6ff,fg=#0f1419,bold] 🛸 #{session_name} #[default]'

      # Right status: Basic cyberpunk dashboard (STEP BY STEP, BRIGHTER)
      set -g status-right '#[bg=#394758,fg=#ffffff] ⚡ %H:%M #[default] #[bg=#394758,fg=#ffffff] 📅 %Y-%m-%d #[default]'

      # Cyberpunk window status formatting with brighter colors (SIMPLIFIED)
      set -g window-status-current-format '#[bg=#00e6ff,fg=#0f1419,bold] 🌌 #I:#W #[default]'
      set -g window-status-format '#[bg=#394758,fg=#ffffff] 📄 #I:#W #[default]'
      set -g window-status-separator ""

      # Enhanced pane styling with brighter cyberpunk borders for server visibility
      set -g pane-border-style "fg=#394758"
      set -g pane-active-border-style "fg=#00e6ff,bright"

      # Better window list colors (optimized for headless)
      set -g window-status-style "fg=#ffffff"
      set -g window-status-current-style "fg=#00e6ff,bold"

      # Mouse and navigation settings
      set -g mouse on
      set -g xterm-keys on

      # Custom key bindings
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Enhanced navigation
      bind -n S-Up select-pane -U
      bind -n S-Down select-pane -D
      bind -n S-Left select-pane -L
      bind -n S-Right select-pane -R

      bind -n C-Up resize-pane -U 5
      bind -n C-Down resize-pane -D 5
      bind -n C-Left resize-pane -L 5
      bind -n C-Right resize-pane -R 5

      bind w select-pane -t :.+ # next window

      # Cyberpunk config reload for server
      bind r source-file ~/.tmux.conf \; display-message "🚀 Cyberpunk Server Config Reloaded!"

      # Window and session management enhancements
      set -g base-index 1           # Start window numbering at 1
      set -g pane-base-index 1      # Start pane numbering at 1
      set -g renumber-windows on    # Renumber windows when one is closed

      # Visual enhancements optimized for server/SSH use
      set -g display-time 2000      # Display messages for 2 seconds
      set -g display-panes-time 2000 # Display pane numbers for 2 seconds

      # History and buffer settings
      set -g history-limit 10000    # Increase scrollback buffer

      # Activity monitoring with brighter cyberpunk styling for server visibility
      set -g monitor-activity on
      set -g visual-activity off
      set -g window-status-activity-style "fg=#ff0080,bold"
    '';
  };
}
