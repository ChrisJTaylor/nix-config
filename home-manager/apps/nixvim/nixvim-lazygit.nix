{ ... }: {
  
  programs.nixvim = {

    plugins.lazygit = {
      enable = true;
      autoLoad = true;

      settings = {

      };
    };

  };
}

