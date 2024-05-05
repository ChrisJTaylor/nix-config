{ ... }: {
  
  imports = [
    ./nixvim-keymaps.nix
  ];

  programs.nixvim = {
    enable = true;

    colorschemes.tokyonight.enable = true;

    plugins.lightline.enable = true;
    plugins.navic.enable = true;
    plugins.which-key.enable = true;

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

    plugins.lsp = {
      enable = true;
      servers = {
	nil_ls.enable = true;
      };
      keymaps.lspBuf = {
	K = "hover";
	gD = "references";
	gd = "definition";
	gi = "implementation";
	gt = "type_definition";
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
      sources = [
        {name = "nvim_lsp";}
        {name = "path";}
        {name = "buffer";}
        {name = "luasnip";}
      ];
      mapping = {
	"<CR>" = "cmp.mapping.confirm({ select = true })";
	"<Tab>" = {
	  action = ''
	    function(fallback)
	      if cmp.visible() then
	        cmp.select_next_item()
	      else
	        fallback()
	      end
	    end
	  '';
	  modes = [ "i" "s" ];
	};
      };
    };

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

  };
}
