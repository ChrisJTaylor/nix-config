{ ... }: {
  
  programs.nixvim = {

    plugins = {

      gitblame = {
        enable = true;
      };

      gitgutter = {
        enable = true;
      };

      git-worktree = {
        enable = true;
      };

      git-conflict = {
        enable = true;
      };

      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = false;
          signcolumn = true;
          signs = {
            add = {
              text = "+";
            };
            change = {
              text = "│";
            };
            changedelete = {
              text = "~";
            };
            delete = {
              text = "_";
            };
            topdelete = {
              text = "‾";
            };
            untracked = {
              text = "┆";
            };
          };
          watch_gitdir = {
            follow_files = true;
          };
        };
      };

    };

  };

}

