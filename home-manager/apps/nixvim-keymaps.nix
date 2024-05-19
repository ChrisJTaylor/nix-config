{ ... }: {

  programs.nixvim = {

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = [
    {
      mode = "n";
      key = "<ESC>";
      action = "<cmd>nohlsearch<CR>";
    }
    {
      mode = "n";
      key = "<leader>ef";
      options.silent = true;
      action = "<cmd>:Neotree filesystem reveal<CR>";
      options.desc = "Filesystem";
    }
    {
      mode = "n";
      key = "<leader>efl";
      options.silent = true;
      action = "<cmd>:Neotree filesystem reveal left<CR>";
      options.desc = "Show file explorer (left)";
    }
    {
      mode = "n";
      key = "<leader>efr";
      options.silent = true;
      action = "<cmd>:Neotree filesystem reveal right<CR>";
      options.desc = "Show file explorer (right)";
    }
    {
      mode = "n";
      key = "<leader>eb";
      options.silent = true;
      action = "<cmd>:Neotree buffers reveal<CR>";
      options.desc = "Open files";
    }
    {
      mode = "n";
      key = "<leader>ebl";
      options.silent = true;
      action = "<cmd>:Neotree buffers reveal left<CR>";
      options.desc = "Show all open files in explorer (left)";
    }
    {
      mode = "n";
      key = "<leader>ebr";
      options.silent = true;
      action = "<cmd>:Neotree buffers reveal right<CR>";
      options.desc = "Show all open files in explorer (right)";
    }
    {
      mode = "n";
      key = "<leader>eg";
      options.silent = true;
      action = "<cmd>:Neotree git_status reveal<CR>";
      options.desc = "Changed files";
    }
    {
      mode = "n";
      key = "<leader>egl";
      options.silent = true;
      action = "<cmd>:Neotree git_status reveal left<CR>";
      options.desc = "Show git status in explorer (left)";
    }
    {
      mode = "n";
      key = "<leader>egr";
      options.silent = true;
      action = "<cmd>:Neotree git_status reveal right<CR>";
      options.desc = "Show git status in explorer (right)";
    }
    {
      mode = "n";
      key = "<leader>q";
      options.silent = true;
      action = "<cmd>:q!<CR>";
      options.desc = "Quit";
    }
    {
      mode = "n";
      key = "<leader>|";
      options.silent = true;
      action = "<C-w><C-v>";
      options.desc = "Split across";
    }
    {
      mode = "n";
      key = "<leader>-";
      options.silent = true;
      action = "<C-w><C-s>";
      options.desc = "Split down";
    }
    {
      mode = "n";
      key = "<leader>w";
      options.silent = true;
      action = "<C-w><C-w>";
      options.desc = "Switch windows";
    }
    {
      mode = "n";
      key = "<leader>c";
      options.silent = true;
      action = "<C-w><C-q>";
      options.desc = "Close window";
    }
    {
      mode = "n";
      key = "<leader>m";
      options.silent = true;
      action = "<cmd>:marks<CR>";
      options.desc = "List all marks";
    }
    {
      mode = "n";
      key = "<C-u>";
      options.silent = true;
      action = "<C-u>zz";
      options.desc = "Move up";
    }
    {
      mode = "n";
      key = "<C-d>";
      options.silent = true;
      action = "<C-d>zz";
      options.desc = "Move down";
    }
    {
      mode = "n";
      key = "G";
      options.silent = true;
      action = "Gzz";
      options.desc = "Move to the end";
    }
    {
      mode = "n";
      key = "t";
      options.silent = true;
      action = "<cmd>:ter<CR>";
      options.desc = "Open a terminal window";
    }
    {
      mode = "n";
      key = "<C-h>";
      options.silent = true;
      action = "<C-w><C-h>";
      options.desc = "Move focus to left window";
    }
    {
      mode = "n";
      key = "<C-j>";
      options.silent = true;
      action = "<C-w><C-j>";
      options.desc = "Move focus to lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      options.silent = true;
      action = "<C-w><C-k>";
      options.desc = "Move focus to upper window";
    }
    {
      mode = "n";
      key = "<C-l>";
      options.silent = true;
      action = "<C-w><C-l>";
      options.desc = "Move focus to right window";
    }
    {
      mode = "n";
      key = "<leader>y";
      options.silent = true;
      action = ''"+y'';
      options.desc = "Yank to clipboard";
    }
    {
      mode = "n";
      key = "<leader>p";
      options.silent = true;
      action = ''"+p'';
      options.desc = "Paste from clipboard";
    }
    {
      mode = "n";
      key = "<leader>={";
      options.silent = true;
      action = "=%";
      options.desc = "re-indent block with braces";
    }
    {
      mode = "n";
      key = "<leader>=(";
      options.silent = true;
      action = ">ib";
      options.desc = "Indent inner block with parentheses";
    }
    {
      mode = "n";
      key = "<leader>=<";
      options.silent = true;
      action = ">at";
      options.desc = "Indent inner block with angle brackets";
    }
    {
      mode = "n";
      key = "K";
      options.silent = true;
      action = "<CMD>Lspsaga hover_doc<Enter>";
      options.desc = "Tooltip";
    }
    
    # Lspsaga
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

    plugins.lsp.keymaps = {
      lspBuf = {
	gD = "references";
	gd = "definition";
	gi = "implementation";
	gt = "type_definition";
      };
    };


    plugins.nvim-cmp.mapping = {
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
}

