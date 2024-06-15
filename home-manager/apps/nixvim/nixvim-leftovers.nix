{ ... }: {

  programs.nixvim = {

    keymaps = [
# Lspsaga
    {
      mode = "n";
      key = "K";
      options.silent = true;
      action = "<CMD>Lspsaga hover_doc<Enter>";
      options.desc = "Tooltip";
    }
    {
      mode = "n";
      key = "<leader>a";
      options.silent = true;
      action = "<cmd>:Lspsaga code_action<CR>";
      options.desc = "Show code actions";
    }
    {
      mode = "n";
      key = "<leader>t";
      options.silent = true;
      action = "<cmd>:Lspsaga term_toggle<CR>";
      options.desc = "Show floating terminal";
    }
    {
      mode = "n";
      key = "<leader>k";
      options.silent = true;
      action = "<cmd>:Lspsaga hover_doc<CR>";
      options.desc = "Show doc";
    }
    {
      mode = "n";
      key = "<leader>K";
      options.silent = true;
      action = "<cmd>:Lspsaga hover_doc ++keep<CR>";
      options.desc = "Show doc (keep open)";
    }
    {
      mode = "n";
      key = "<leader>f";
      options.silent = true;
      action = "<cmd>:Lspsaga finder ref<CR>";
      options.desc = "Show LSP finder (references)";
    }
    {
      mode = "n";
      key = "<leader>F";
      options.silent = true;
      action = "<cmd>:Lspsaga finder def+ref+imp<CR>";
      options.desc = "Show LSP finder (definitions, references and implementations";
    }
    ];

  };

	 }
