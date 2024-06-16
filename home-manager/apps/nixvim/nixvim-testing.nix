{ ... }: {
  
  programs.nixvim = {

    plugins.neotest = {
      enable = true;
      adapters = {
        dotnet = {
	  enable = true;
	  settings = {
	    discovery_root = "solution";
	  };
	};
      };

      settings = {
        log_level = 1;
	diagnostic = {
	  enabled = true;
	  severity = "error";
	};
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
	status = {
	  enabled = true;
	  signs = true;
	};
	state = {
	  enabled = true;
	};
	discovery = {
	  enabled = true;
	};
	summary = {
	  enabled = true;
	  animated = true;
	  expandErrors = true;
	  follow = true;
	  open = "botright vsplit | vertical resize 50";
	  mappings = {
	    attach = "a";
	      clear_marked = "M";
	      clear_target = "T";
	      debug = "d";
	      debug_marked = "D";
	      expand = ["<CR>" "<2-LeftMouse>"];
	      expand_all = "e";
	      jumpto = "i";
	      mark = "m";
	      next_failed = "J";
	      output = "o";
	      prev_failed = "K";
	      run = "r";
	      run_marked = "R";
	      short = "O";
	      stop = "u";
	      target = "t";
	      watch = "w";
	  };
	};
      };
    };

  };
}

