{ ... }: {
  
  programs.nixvim = {

    plugins.lsp-status = {
      enable = true;
    };

    plugins.lsp-lines = {
      enable = true;
    };

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
	    enableDecompilationSupport = true;
	  };
	};
        pylsp = {
	  enable = true;
	  autostart = true;
	};
	gopls = {
	  enable = true;
	  autostart = true;
	};
	html = {
	  enable = true;
	  autostart = true;
	};
	lua-ls = {
	  enable = true;
	  autostart = true;
	};
	rust-analyzer = {
	  enable = true;
	  autostart = true;
	  installCargo = true;
	  installRustc = true;
	};
	terraformls = {
	  enable = true;
	  autostart = true;
	};
	yamlls = {
	  enable = true;
	  autostart = true;
	};
	bashls = {
	  enable = true;
	  autostart = true;
	};
	gleam = {
	  enable = true;
	  autostart = true;
	};
	marksman = {
	  enable = true;
	  autostart = true;
	};
      };
    };

  };
}

