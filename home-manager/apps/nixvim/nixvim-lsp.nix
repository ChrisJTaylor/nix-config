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
      servers = {
        nil-ls = {
          enable = true;
          settings = {
            nix = {
              maxMemoryMB = 8192;
              flake = {
                autoArchive = true;
                autoEvalInputs = true;
              };
            };
          };
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
	    enableDecompilationSupport = true;
	  };
	};
        pylsp = {
	  enable = true;
	  autostart = true;
          settings = {
            configurationSources = "pycodestyle";
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
        kotlin-language-server = {
          enable = true;
          autostart = true;
        };
	lua-ls = {
	  enable = true;
	  autostart = true;
          settings = {
            completion = {
              enable = true;
              callSnippet = "Both";
              displayContext = 4;
              keywordSnippet = "Both";
              showParams = true;
              showWord = "Enable";
              workspaceWord = true;
            };
            format = {
              enable = true;
            };
            hint = {
              enable = true;
            };
            hover = {
              enable = true;
              enumsLimit = 5;
              expandAlias = true;
              previewField = 50;
              viewNumber = true;
              viewString = true;
              viewStringMax = 1000;
            };
            semantic = {
              enable = true;
              annotation = true;
              keyword = true;
              variable = true;
            };
            signatureHelp.enable = true;
            spell.dict = [
            ];
            telemetry.enable = true;
          };
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

