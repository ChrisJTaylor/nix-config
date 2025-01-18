{ ... }: {

  programs.nixvim = {

    plugins.zig = {
      enable = true;
      settings = {
      };
    };

  };

}
