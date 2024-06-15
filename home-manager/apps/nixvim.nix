{ ... }: {
  
  imports = [
    ./nixvim/nixvim-keymaps.nix
#    ./nixvim/nixvim-highlight.nix
#    ./nixvim/nixvim-autocmds.nix
    ./nixvim/nixvim-lsp-exp.nix
#    ./nixvim/nixvim-testing.nix
#    ./nixvim/nixvim-treesitter.nix
#    ./nixvim/nixvim-git.nix
#    ./nixvim/nixvim-godot.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    plugins.neo-tree = {
      enable = true;
      enableGitStatus = true;
      enableModifiedMarkers = true;
      enableRefreshOnWrite = true;
      closeIfLastWindow = true;
    };
  };
}

