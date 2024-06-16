{ ... }: {

  programs.nixvim = {

    plugins.treesitter = {
      enable = true;
      ensureInstalled = "all";
      folding = false;
      nixvimInjections = true;
      nixGrammars = true;
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
