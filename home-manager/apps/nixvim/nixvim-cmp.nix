{ pkgs, ... }: {
  
  programs.nixvim = {

    plugins.dap = {
      enable = true;
      package = pkgs.vimPlugins.nvim-dap;
    };
    plugins.cmp-nvim-lsp.enable = true;
    plugins.cmp-buffer.enable = true;
    plugins.cmp-path.enable = true;
    plugins.cmp_luasnip.enable = true;

    plugins.friendly-snippets.enable = true;
    plugins.luasnip.enable = true;

    plugins.cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        autocomplete = ["require('cmp.types').cmp.TriggerEvent.TextChanged"];

        view = {
	  entries = {
	    name = "custom";
	    selection_order = "top_down";
	  };
	  docs.auto_open = true;
	};
	preselect = "cmp.PreselectMode.Item";
	sorting = {
	  comparators = [
	    "require('cmp.config.compare').offset"
	    "require('cmp.config.compare').exact"
	    "require('cmp.config.compare').score"
	    "require('cmp.config.compare').recently_used"
	    "require('cmp.config.compare').locality"
	    "require('cmp.config.compare').kind"
	    "require('cmp.config.compare').length"
	    "require('cmp.config.compare').order"
	  ];
	  priority_weight = 2;
	};

	filetype = {
	  bash = {
	    sources = [
	      {
	        name = "nvim_lsp";
	      }
	    ];
	  };
	  javascript = {
	    sources = [
	      {
	        name = "nvim_lsp";
	      }
	    ];
	  };
	  typescript = {
	    sources = [
	      {
	        name = "nvim_lsp";
	      }
	    ];
	  };
	  lua = {
	    sources = [
	      {
	        name = "nvim_lsp";
	      }
	    ];
	  };
	  go = {
	    sources = [
	      {
	        name = "nvim_lsp";
	      }
	    ];
	  };
	  rust = {
	    sources = [
	      {
	        name = "nvim_lsp";
	      }
	    ];
	  };
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
	  powershell = {
	    sources = [
	      {
	        name = "nvim_lsp";
	      }
	    ];
	  };
	  zig = {
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

        snippet.expand = ''
          function(args)
            -- vim.fn["vsnip#anonymous"](args.body)
            require('luasnip').lsp_expand(args.body)
            -- require('snippy').expand_snippet(args.body)
          end
          '';

	mapping = {
	  "<C-Space>" = "cmp.mapping.complete()";

	  "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
	  "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
	  "<CR>" = "cmp.mapping.confirm({ select = true })";

	  "<C-n>" = "cmp.mapping.scroll_docs(4)";
	  "<C-p>" = "cmp.mapping.scroll_docs(-4)";
	  "<C-q>" = "cmp.mapping.close()";
	  "<C-e>" = "cmp.mapping.abort()";
	};

      };

    };

  };
}

