{ ... }: {
  
  imports = [
    ./nixvim-keymaps.nix
    ./nixvim-highlight.nix
    ./nixvim-autocmds.nix
    ./nixvim-lsp.nix
    ./nixvim-testing.nix
    ./nixvim-treesitter.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    colorschemes.tokyonight.enable = true;

    opts = {
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

    clipboard.providers.xclip.enable = true;

    plugins.persistence.enable = true;

    plugins.nvim-lightbulb.enable = false;
    plugins.lightline.enable = true;
    plugins.navic.enable = true;
    plugins.which-key.enable = true;
    plugins.surround.enable = true;

    plugins.neo-tree = {
      enable = true;
      enableGitStatus = true;
      enableModifiedMarkers = true;
      enableRefreshOnWrite = true;
      closeIfLastWindow = true;
    };

    plugins.refactoring.enable = true;
    plugins.refactoring.enableTelescope = true;

    plugins.telescope = {
      enable = true;
      keymaps = {
	"<C-p>" = {
	  action = "git_files";
	    options = {
	      desc = "Telescope Git Files";
	    };
	};
	"<leader>fg" = "live_grep";
      };
      settings = {
        defaults = {
	  file_ignore_patterns = [
	    "^.git/"
            "^.mypy_cache/"
            "^__pycache__/"
            "^output/"
            "^data/"
            "%.ipynb"
	  ];
	};
      };
    };

  };
}

