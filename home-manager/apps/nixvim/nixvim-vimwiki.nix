{ ... }: {

  programs.nixvim = {

    plugins.vimwiki = {
      enable = true;
      settings = {
        autowriteall = 0;
        list = [
          {
            path = "~/docs/notes/";
          }
        ];
        use_calendar = 1;
      };
    };

  };

}

