{ ... }: {
  
  programs.nixvim = {

    plugins.gitblame = {
      enable = true;
    };

    plugins.gitgutter = {
      enable = false;
    };

    plugins.git-worktree = {
      enable = true;
    };

    plugins.git-conflict = {
      enable = true;
    };

  };

}

