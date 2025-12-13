{approved-packages, ...}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    newSession = true;
    terminal = "tmux-256color";  # Upgraded for better color support
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
      
      # ===== CYBERPUNK SPACE THEME CONFIGURATION (SERVER OPTIMIZED) =====
      
      # Enhanced color support for headless environments
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -ag terminal-overrides ",screen-256color:RGB"
      set -ag terminal-overrides ",tmux-256color:RGB"
      
      # Enable true color support
      set-option -sa terminal-overrides ',*:RGB'
      set-option -ga terminal-overrides ',*:Tc'
      
      # Status bar positioning and update intervals
      set -g status-position top
      set -g status-interval 5
      set -g status-justify left
      
      # Brighter cyberpunk space theme for server/SSH visibility
      set -g @tmux_power_theme '#0f1419'
      set -g @tmux_power_g0 "#0f1419"    # Brighter deep space
      set -g @tmux_power_g1 "#1f1f3a"    # Brighter space purple
      set -g @tmux_power_g2 "#394758"    # Brighter border inactive  
      set -g @tmux_power_g3 "#00e6ff"    # Brighter neon cyan
      set -g @tmux_power_g4 "#ff0080"    # Brighter neon magenta
      
      # Enhanced status bar styling with better contrast
      set -g status-style "bg=#0f1419,fg=#ffffff"
      set -g status-left-style "bg=#00e6ff,fg=#0f1419"
      set -g status-right-style "bg=#00e6ff,fg=#0f1419"
      
      # Left side: Session name with cyberpunk prefix indicator (brighter)
      set -g status-left '#{?client_prefix,#[bg=#ff0080,fg=#ffffff,bold] 🔴 PREFIX #[default],#[bg=#00e6ff,fg=#0f1419,bold] 🛸 #S #[default]}'
      set -g status-left-length 30
      
      # Right side: Comprehensive status with traffic light CPU, battery, network, git, time (brighter colors)
      set -g status-right '#{?#{>=:#{cpu_percentage},67},#[bg=#ff0080,fg=#ffffff] 🔥 CPU #{cpu_percentage}% #[default],#{?#{>=:#{cpu_percentage},34},#[bg=#ffcc0b,fg=#0f1419] ⚡ CPU #{cpu_percentage}% #[default],#[bg=#00ff99,fg=#0f1419] ✅ CPU #{cpu_percentage}% #[default]}} #[bg=#394758,fg=#ffffff] 🔋 #(if command -v pmset >/dev/null 2>&1; then pmset -g batt | grep -Eo "[0-9]+%" | head -1; elif command -v acpi >/dev/null 2>&1; then acpi -b | grep -Eo "[0-9]+%" | head -1; else echo "N/A"; fi) #[default] #[bg=#394758,fg=#ffffff] 🌐 #(ping -c1 -W1 8.8.8.8 >/dev/null 2>&1 && echo "✓" || echo "✗") #[default] #[bg=#394758,fg=#ffffff] 📅 %b-%d #[default] #[bg=#394758,fg=#ffffff] 🌲 #(cd #{pane_current_path} 2>/dev/null && git branch 2>/dev/null | grep "^*" | cut -c 3-10 || echo "no-git") #[default] #[bg=#00e6ff,fg=#0f1419] ⚡ %H:%M #[default]'
      set -g status-right-length 140
      
      # Cyberpunk window status formatting with WIN- prefix (brighter)
      set -g window-status-current-format '#[bg=#00e6ff,fg=#0f1419,bold] 🌌 WIN-#{?#{>=:#{window_index},10},#{window_index},0#{window_index}}:#W#{?window_zoomed_flag, 🔍,} #[default]'
      set -g window-status-format '#[bg=#394758,fg=#ffffff] 📄 WIN-#{?#{>=:#{window_index},10},#{window_index},0#{window_index}}:#W #[default]'
      set -g window-status-separator ""

      # Plugin configurations
      set -g @continuum-boot-options 'on'
      run-shell ${approved-packages.tmux-cpu}/share/tmux-plugins/cpu/cpu.tmux

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
      
      # Better pane border colors (brighter for server visibility)
      set -g pane-border-style "fg=#394758"
      set -g pane-active-border-style "fg=#00e6ff,bright"
      
      # Enhanced pane border format
      set -g pane-border-format '#{?pane_active,#[bg=#00e6ff,fg=#0f1419] ⚡#{pane_index} #[default],#{pane_index}}'
      
      # Better window list colors (optimized for headless)
      set -g window-status-style "fg=#ffffff"
      set -g window-status-current-style "fg=#00e6ff,bold"
      
      # Cyberpunk config reload with visual feedback
      bind r source-file ~/.config/home-manager/home.conf \; display-message "🚀 Cyberpunk Server Config Reloaded!"
    '';
  };
}