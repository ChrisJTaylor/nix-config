{ ... }: {

  programs.nixvim = {

    highlight = {
      Comment = {
        fg = "#000000";
        bg = "#FFFFFF";
        italic = true;
      };
    };

  };

}
