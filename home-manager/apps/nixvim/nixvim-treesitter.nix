{ ... }: {

  programs.nixvim = {

    plugins.treesitter = {
      enable = true;
      ensureInstalled = "all";
      folding = false;
      nixvimInjections = true;
    };

    plugins.treesitter-context = {
      enable = true;
      settings = {
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

  };

}
