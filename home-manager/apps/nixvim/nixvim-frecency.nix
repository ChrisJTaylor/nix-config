{ ... }: {
  
  programs.nixvim = {

    plugins = {
      telescope.extensions.frecency = {
        enable = true;
      };
    };

  };

}

