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
      };

      settings = {
        log_level = 1;
        output = {
	  enabled = true;
	  open_on_run = true;
	};
	output_panel = {
	  enabled = false;
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
          virtual_text = true;
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

