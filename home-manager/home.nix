{ config, pkgs, ... }:

let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "nixos-23.11";
  });
in
{
  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "SauceCodePro" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    (pkgs.writeShellScriptBin "my-hello" ''
      echo "Hello, ${config.home.username}!"
    '')
  ];

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
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nixos/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    initExtraFirst = ''
      alias ls="eza --color=always --long --git --no-filesize --icons=always --no-user --no-permissions"
      alias vim=nvim
    
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
    '';
    initExtra = ''
      source ~/fzf-git.sh/fzf-git.sh
      source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
    
      eval "$(atuin init zsh)"
      eval "$(direnv hook zsh)"
      eval "$(zoxide init zsh --cmd cd)"
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.navi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.nixvim = {
    enable = true;

    colorschemes.tokyonight.enable = true;

    plugins.lightline.enable = true;
    plugins.navic.enable = true;
    plugins.which-key.enable = true;

    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      clipboard = "unnamedplus";
      undofile = true;
      ignorecase = true;
      smartcase = true;
      timeoutlen = 300;
      splitright = true;
      splitbelow = true;
      scrolloff = 10;
      hlsearch = true;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = [
      {
        mode = "n";
	key = "<ESC>";
	action = "<cmd>nohlsearch<CR>";
      }
      {
        mode = "n";
        key = "<leader>q";
        options.silent = true;
        action = "<cmd>:q!<CR>";
	options.desc = "Quit";
      }
      {
        mode = "n";
        key = "<leader>|";
        options.silent = true;
        action = "<C-w><C-v>";
	options.desc = "Split across";
      }
      {
        mode = "n";
        key = "<leader>-";
        options.silent = true;
        action = "<C-w><C-s>";
	options.desc = "Split down";
      }
      {
        mode = "n";
        key = "<leader>w";
        options.silent = true;
        action = "<C-w><C-w>";
	options.desc = "Switch windows";
      }
      {
        mode = "n";
        key = "<leader>c";
        options.silent = true;
        action = "<C-w><C-q>";
	options.desc = "Close window";
      }
      {
        mode = "n";
        key = "<leader>m";
        options.silent = true;
        action = "<cmd>:marks<CR>";
	options.desc = "List all marks";
      }
      {
        mode = "n";
        key = "<C-u>";
        options.silent = true;
        action = "<C-u>zz";
	options.desc = "Move up";
      }
      {
        mode = "n";
        key = "<C-d>";
        options.silent = true;
        action = "<C-d>zz";
	options.desc = "Move down";
      }
      {
        mode = "n";
        key = "G";
        options.silent = true;
        action = "Gzz";
	options.desc = "Move to the end";
      }
      {
        mode = "n";
        key = "t";
        options.silent = true;
        action = "<cmd>:ter<CR>";
	options.desc = "Open a terminal window";
      }
      {
        mode = "n";
        key = "<C-h>";
        options.silent = true;
        action = "<C-w><C-h>";
	options.desc = "Move focus to left window";
      }
      {
        mode = "n";
        key = "<C-j>";
        options.silent = true;
        action = "<C-w><C-j>";
	options.desc = "Move focus to lower window";
      }
      {
        mode = "n";
        key = "<C-k>";
        options.silent = true;
        action = "<C-w><C-k>";
	options.desc = "Move focus to upper window";
      }
      {
        mode = "n";
        key = "<C-l>";
        options.silent = true;
        action = "<C-w><C-l>";
	options.desc = "Move focus to right window";
      }
      {
        mode = "n";
        key = "<leader>y";
        options.silent = true;
	action = ''"+y'';
	options.desc = "Yank to clipboard";
      }
      {
        mode = "n";
        key = "<leader>p";
        options.silent = true;
	action = ''"+p'';
	options.desc = "Paste from clipboard";
      }
      {
	mode = "n";
	key = "<leader>={";
	options.silent = true;
	action = "=%";
	options.desc = "re-indent block with braces";
      }
      {
	mode = "n";
	key = "<leader>=(";
	options.silent = true;
	action = ">ib";
	options.desc = "Indent inner block with parentheses";
      }
      {
	mode = "n";
	key = "<leader>=<";
	options.silent = true;
	action = ">at";
	options.desc = "Indent inner block with angle brackets";
      }
    ];
  };

}
