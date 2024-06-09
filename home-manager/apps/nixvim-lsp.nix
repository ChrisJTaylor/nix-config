{ ... }: {
  
  programs.nixvim = {

    plugins.lspsaga.enable = true;
    plugins.lspsaga.lightbulb.enable = false;

    plugins.lsp = {
      enable = true;
      capabilities = "";
      servers = {
	nil_ls.enable = true;
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

