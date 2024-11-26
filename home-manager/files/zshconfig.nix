{ ... }:

{
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".zshrc".text = ''
      alias ls="eza --color=always --long --git --no-filesize --icons=always --no-user --no-permissions"
      alias vim=nvim
      alias v="nvim v"
      alias gst="git status"
    
      source "$(fzf-share)/key-bindings.zsh"
      source "$(fzf-share)/completion.zsh"
      
      export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
    
      _fzf_compgen_path() {
        fs --hidden --exclude .git . "$1"
      }
    
      _fzf_compgen_dir() {
        fd --type=d --hidden --exclude .git . "$1"
      }
    
      export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
      export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
    
      # Advanced customization of fzf options via _fzf_comprun function
      # - The first argument to the function is the name of the command.
      # - You should make sure to pass the rest of the arguments to fzf.
      _fzf_comprun() {
        local command=$1
        shift
    
        case "$command" in
          cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
          export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
          ssh)          fzf --preview 'dig {}'                   "$@" ;;
          *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
        esac
      }

      source ~/fzf-git.sh/fzf-git.sh
      # source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
    
      eval "$(atuin init zsh)"
      eval "$(direnv hook zsh)"
      eval "$(zoxide init zsh --cmd cd)"

      bindkey -v
    '';
  };
}
