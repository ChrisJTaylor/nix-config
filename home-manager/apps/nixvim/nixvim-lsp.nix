{ ... }: {
  
  programs.nixvim = {

    plugins.lsp-format = {
      enable = true;
      lspServersToEnable = "all";
    };

    plugins.lsp-lines = {
      enable = true;
    };

    plugins.lspsaga = {
      enable = true;
      lightbulb = {
        enable = false;
	virtualText = true;
      };
      outline = {
        autoPreview = true;
	detail = true;
      };
      rename = {
        autoSave = true;
      };
      implement = {
        enable = true;
	virtualText = true;
      };
      hover = {
        maxHeight = 0.8;
	maxWidth = 0.9;
      };
    };

    plugins.lsp = {
      enable = true;
      capabilities = "";
      servers = {
	nil-ls.enable = true;
        pylsp = {
	  enable = true;
	  autostart = true;
	};
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

    plugins.cmp.settings.mapping = {
      "<C-Space>" = "cmp.mapping.complete()";
      "<CR>" = "cmp.mapping.confirm({ select = true })";
      "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
    };

  };
}

