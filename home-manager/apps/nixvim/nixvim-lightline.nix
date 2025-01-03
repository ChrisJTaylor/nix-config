{ ... }: {

  programs.nixvim = {

    plugins.lightline = {
      enable = true;
      autoReload = true;

      settings = {
        active = {
          right = [
            [
              "lineinfo"
            ]
            [
              "percent"
            ]
            [
              "fileformat"
              "fileencoding"
              "filetype"
              "charvaluehex"
            ]
          ];
        };
        colorscheme = "one";
        component = {
          charvaluehex = "0x%B";
          lineinfo = "%3l:%-2v%<";
        };
        component_function = {
          gitbranch = "FugitiveHead";
        };
        inactive = [ ];
        mode_map = {
          "<C-s>" = "SB";
          "<C-v>" = "VB";
          i = "I";
          n = "N";
          v = "V";
        };
      };

    };

  };
}

