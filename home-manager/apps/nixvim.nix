{ ... }: {
  
  imports = [
    ./nixvim/nixvim-keymaps.nix
    ./nixvim/nixvim-autocmds.nix
    ./nixvim/nixvim-autosave.nix
    ./nixvim/nixvim-telescope.nix
    ./nixvim/nixvim-treesitter.nix
    ./nixvim/nixvim-frecency.nix
    ./nixvim/nixvim-cmp.nix
    ./nixvim/nixvim-lsp.nix
    ./nixvim/nixvim-navic.nix
    ./nixvim/nixvim-neotree.nix
    ./nixvim/nixvim-lspsaga.nix
    ./nixvim/nixvim-testing.nix
    ./nixvim/nixvim-coverage.nix
    ./nixvim/nixvim-git.nix
    ./nixvim/nixvim-devicons.nix
    ./nixvim/nixvim-extraConfigLua.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    colorschemes.kanagawa.enable = true;

    clipboard.providers.xclip.enable = true;

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      clipboard = "unnamedplus";
      undofile = true;
      ignorecase = true;
      smartcase = true;
      timeoutlen = 300;
      splitright = true;
      splitbelow = true;
      scrolloff = 10;
      hlsearch = true;
    };

    plugins.dressing.enable = true;

    plugins.which-key.enable = true;

    plugins.nix.enable = true;
    plugins.nix-develop.enable = true;

    plugins.hardtime.enable = false;

    plugins.rainbow-delimiters.enable = true;
  };
}

