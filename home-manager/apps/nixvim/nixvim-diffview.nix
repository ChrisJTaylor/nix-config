{ ... }: {

  programs.nixvim = {

    plugins.diffview = {
      enable = true;

      keymaps.view = [
        {
          action = "actions.select_next_entry";
          description = "Open the diff for the next file";
          key = "<tab>";
          mode = "n";
        }

      ];

    };
  };

}

