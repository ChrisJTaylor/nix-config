{ ... }: {
  
  imports = [
    ./nixvim/nixvim-keymaps.nix
#    ./nixvim/nixvim-highlight.nix
    ./nixvim/nixvim-autocmds.nix
    ./nixvim/nixvim-telescope.nix
    ./nixvim/nixvim-treesitter.nix
    ./nixvim/nixvim-cmp.nix
    ./nixvim/nixvim-lsp-exp.nix
    ./nixvim/nixvim-lspsaga.nix
#    ./nixvim/nixvim-testing.nix
#    ./nixvim/nixvim-git.nix
#    ./nixvim/nixvim-godot.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    colorschemes.cyberdream.enable = true;

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
  };
}

