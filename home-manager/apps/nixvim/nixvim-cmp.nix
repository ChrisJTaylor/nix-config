{ ... }: {
  
  programs.nixvim = {

    plugins.cmp-nvim-lsp.enable = true;

    plugins.cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        autocomplete = ["require('cmp.types').cmp.TriggerEvent,TextChanged,BufReadPre,BufNewFile"];

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

	mapping = {
	  "<C-Space> " = "cmp.mapping.complete()";

	  "<Tab> " = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
	  "<S-Tab> " = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
	  "<CR> " = "cmp.mapping.confirm({ select = true })";

	  "<C-n> " = "cmp.mapping.scroll_docs(4)";
	  "<C-p> " = "cmp.mapping.scroll_docs(-4)";
	  "<C-q> " = "cmp.mapping.close()";
	};

      };

    };

  };
}

