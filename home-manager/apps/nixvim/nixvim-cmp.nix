{ ... }: {
  
  programs.nixvim = {

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

