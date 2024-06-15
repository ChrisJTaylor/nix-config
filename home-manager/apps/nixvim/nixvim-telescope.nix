{ ... }: {

  programs.nixvim = {

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
