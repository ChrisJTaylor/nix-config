{ pkgs, ... }: {

  programs.nixvim = {

    plugins.treesitter = {
      enable = true;

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        json
        lua
        make
        markdown
        regex
        toml
        vim
        vimdoc
        xml
        yaml
      ];

      folding = false;
      nixvimInjections = true;
      nixGrammars = true;
      settings = {
        ensure_installed = "all";
      };
    };

    plugins.treesitter-context = {
      enable = true;
      settings = {
        enable = true;
	mode = "topline";
	line_numbers = true;
      };
    };

    plugins.treesitter-refactor = {
      enable = true;
      highlightCurrentScope.enable = true;
      highlightDefinitions = {
        enable = true;
        clearOnCursorMove = true;
      };      
      navigation.enable = true;
      smartRename.enable = true;
    };

    plugins.refactoring.enable = true;
    plugins.refactoring.enableTelescope = true;

  };

}
