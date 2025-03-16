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
    ./nixvim/nixvim-zig.nix
    ./nixvim/nixvim-smear-cursor.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    colorschemes.cyberdream = {
      enable = true;
      settings = {
        borderless_telescope = true;
        hide_fillchars = true;
        italic_comments = true;
        terminal_colors = true;
        theme = {
          colors = {
            bg = "#000000";
            bg_alt = "##44F24F";
            bg_highlight = "#ff5ef1";
            grey = "#0D0D0D";
            fg = "#ffffff";
            blue = "#34BF49";
            green = "#44F24F";
            cyan = "#44F24F";
            # red = "#01260A";
            yellow = "#44F24F";
            # magenta = "#ff5ef1";
            # pink = "#ff5ea0";
            orange = "#12732A";
            # purple = "#bd5eff";
          };
          highlights = {
            Comment = {
              bg = "#01260A";
              fg = "#12732A";
            };
          };
          transparent = true;
        };
      };
    };

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
    plugins.neo-tree = {
      enable = true;
      enableGitStatus = true;
      enableModifiedMarkers = true;
      enableRefreshOnWrite = true;
      closeIfLastWindow = true;
    };

    plugins.precognition.enable = true;

    plugins.which-key.enable = true;

    plugins.nix.enable = true;
    plugins.nix-develop.enable = true;

    plugins.rainbow-delimiters.enable = true;
  };
}

