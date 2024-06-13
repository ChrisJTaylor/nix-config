{ ... }: {
  
  programs.nixvim = {

    plugins.gitblame = {
      enable = true;
    };

    plugins.gitgutter = {
      enable = true;
    };

    plugins.git-worktree = {
      enable = true;
    };

    plugins.git-conflict = {
      enable = true;
    };

  };

}

