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
      extensions = {
        fzf-native = {
          enable = true;
          settings = {
            case_mode = "ignore_case";
            fuzzy = true;
            override_file_sorter = true;
            override_generic_sorter = true;
          };
        };
        undo = {
          enable = true;
          settings = {
            entry_format = "state #$ID";
            mappings = {
              i = {
                "<c-cr>" = "require('telescope-undo.actions').restore";
                "<cr>" = "require('telescope-undo.actions').yank_additions";
                "<s-cr>" = "require('telescope-undo.actions').yank_deletions";
              };
              n = {
                Y = "require('telescope-undo.actions').yank_deletions";
                u = "require('telescope-undo.actions').restore";
                y = "require('telescope-undo.actions').yank_additions";
              };
            };
            side_by_side = true;
            time_format = "!%Y-%m-%dT%TZ";
            use_custom_command = [
              "bash"
              "-c"
              "echo '$DIFF' | delta"
              ];
              use_delta = true;
              vim_diff_opts = {
              ctxlen = 8;
              };
              };
        };
      };

    };

  };

}
