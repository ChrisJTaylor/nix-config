{ ... }: {
  
  programs.nixvim = {

    plugins.obsidian = {
      enable = true;
      settings = {
        completion = {
          min_chars = 2;
          nvim_cmp = true;
        };
        ui.enable = true;
        picker = {
          name = "telescope.nvim";
        };
        templates = {
          date_format = "%Y-%m-$d";
          time_format = "%H:%M";
        };
        workspaces = [
          {
            name = "Personal";
            path = "~/workarea/obsidian_vaults/Personal";
          }
          {
            name = "Waters";
            path = "~/workarea/obsidian_vaults/Waters";
          }
        ];

      };
    };

  };

}

