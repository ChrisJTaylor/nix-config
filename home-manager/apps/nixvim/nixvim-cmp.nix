{pkgs, ...}: {
  programs.nixvim = {
    plugins.dap = {
      enable = true;
      package = pkgs.vimPlugins.nvim-dap;
    };

    plugins.nvim-cmp = {
      enable = true;
      sources = [
        {
          name = "nvim_lsp";
        }
      ];
    };
  };
}
