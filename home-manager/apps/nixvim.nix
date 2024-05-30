{ pkgs, ... }: {
  
  imports = [
    ./nixvim-keymaps.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    colorschemes.tokyonight.enable = true;

    options = {
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

    clipboard.providers.xclip.enable = true;

    plugins.neotest = {
      enable = true;
      adapters = {
        dotnet = {
	  enable = true;
	};
        go = {
	  enable = true;
	};
        java = {
	  enable = true;
	};
        plenary = {
	  enable = true;
	};
        rust = {
	  enable = true;
	};
        rspec = {
	  enable = true;
	};
        python = {
	  enable = true;
	};
        scala = {
	  enable = true;
	};
        zig = {
	  enable = true;
	};
      };
      settings = {
        output = {
	  enabled = true;
	  open_on_run = true;
	};
	output_panel = {
	  enabled = true;
	  open = "botright split | resize 15";
	};
	quickfix = {
	  enabled = true;
	};
	watch = {
	  enabled = true;
	};
	running = {
	  concurrent = true;
	};
	state = {
	  enabled = true;
	};
	discovery = {
	  enabled = true;
	};
      };
    };

    plugins.coverage = {
      enable = true;
      autoReload = true;
      autoReloadTimeoutMs = 1000;
      lang = {
        python = {
	  coverage_file = ".coverage";
	  coverage_command = "coverage json --fail-under=100 -q -o";
	};
	ruby = {
	  coverage_file = "coverage/coverage.json";
	};
      };
    };

    plugins.nvim-lightbulb.enable = false;
    plugins.lightline.enable = true;
    plugins.navic.enable = true;
    plugins.which-key.enable = true;
    plugins.surround.enable = true;

    plugins.auto-save = {
      enable = true;
      enableAutoSave = true;
      triggerEvents = ["InsertLeave" "TextChanged"];
    };

    plugins.neo-tree = {
      enable = true;
      enableGitStatus = true;
      enableModifiedMarkers = true;
      enableRefreshOnWrite = true;
      closeIfLastWindow = true;
    };

    plugins.telescope = {
      enable = true;
    };

    plugins.treesitter = {
      enable = true;
      ensureInstalled = "all";
      folding = false;
      nixvimInjections = true;
    };

    plugins.lspsaga.enable = true;

    plugins.lsp = {
      enable = true;
      servers = {
	nil_ls.enable = true;
      };
      servers = {
        pylsp = {
	  enable = true;
	  autostart = true;
	};
	csharp-ls = {
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
      };
    };

    plugins.nvim-cmp = {
      enable = true;
      autoEnableSources = true;
    };

  };
}

