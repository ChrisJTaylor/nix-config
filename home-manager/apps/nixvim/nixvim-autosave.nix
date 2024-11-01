{ ... }: {

  programs.nixvim = {

    plugins.auto-save = {
      enable = true;
      settings = {
        enabled = true;
        trigger_events = {
          cancel_deferred_save = [
            "InsertEnter"
          ];
          defer_save = [
            "InsertLeave"
            "TextChanged"
          ];
          immediate_save = [
            "BufLeave"
            "FocusLost"
          ];
        };
        write_all_buffers = true;
      };
    };

  };

}

