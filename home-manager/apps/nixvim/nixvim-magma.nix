{pkgs, ...}: {
  programs.nixvim = {
    plugins.magma-nvim = {
      enable = true;
      settings = {
        automatically_open_output = true;
        cell_highlight_group = "CursorLine";
        image_provider = "none";
        output_window_borders = true;
        save_path = {
          __raw = "vim.fn.stdpath('data') .. '/magma'";
        };
        show_mimetype_debug = false;
        wrap_output = true;
      };
    };
  };
}
