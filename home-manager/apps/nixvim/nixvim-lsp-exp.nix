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
	    enableDecompilationSupport = true;
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
    
    plugins.cmp-nvim-lsp.enable = true;

    plugins.cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        autocomplete = ["require('cmp.types').cmp.TriggerEvent,TextChanged,BufReadPre,BufNewFile"];
	view.docs.auto_open = true;
	filetype = {
	  python = {
	    sources = [
	      {
	        name = "nvim_lsp";
	      }
	    ];
	  };
	  dotnet = {
	    sources = [
	      {
	        name = "nvim_lsp";
	      }
	    ];
	  };
	};

        sources = [
	  {
	    name = "nvim_lsp";
	  }
	  {
	    name = "luasnip";
	  }
	  {
	    name = "path";
	  }
	  {
	    name = "buffer";
	  }
	];
      };

    };

  };
}

