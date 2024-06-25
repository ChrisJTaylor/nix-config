{ ... }: {
  
  imports = [
    ./nixvim/nixvim-keymaps.nix
    ./nixvim/nixvim-autocmds.nix
    ./nixvim/nixvim-telescope.nix
    ./nixvim/nixvim-treesitter.nix
    ./nixvim/nixvim-cmp.nix
    ./nixvim/nixvim-lsp.nix
    ./nixvim/nixvim-lspsaga.nix
    ./nixvim/nixvim-testing.nix
    ./nixvim/nixvim-coverage.nix
    ./nixvim/nixvim-git.nix
    ./nixvim/nixvim-obsidian.nix
    ./nixvim/nixvim-godot.nix
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

    plugins.neo-tree = {
      enable = true;
      enableGitStatus = true;
      enableModifiedMarkers = true;
      enableRefreshOnWrite = true;
      closeIfLastWindow = true;
    };

    plugins.dressing.enable = true;

    plugins.lightline.enable = true;
    plugins.which-key.enable = true;

    plugins.diffview.enable = true;

    plugins.nix.enable = true;
    plugins.nix-develop.enable = true;
  };
}

