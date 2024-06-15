{ ... }: {
  
  programs.nixvim = {

    plugins.lsp = {
      enable = true;
      capabilities = "";
      servers = {
	nil-ls.enable = true;
	omnisharp = {
	  enable = true;
	  autostart = true;
	  filetypes = [
	    "cs" "vb" "csproj" "sln" "slnx" "props" "csx" "targets"
	  ];
	  settings = {
	    analyzeOpenDocumentsOnly = true;
	    enableImportCompletion = true;
	    organizeImportsOnFormat = true;
	    enableRoslynAnalyzers = true;
	  };
	};
      };
    };

    plugins.lsp.keymaps = {
      lspBuf = {
	gD = "references";
	gd = "definition";
	gi = "implementation";
	gt = "type_definition";
      };
    };

    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
    };

  };
}

