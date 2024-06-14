{ ... }: {
  
  programs.nixvim = {

    plugins.neotest = {
      enable = true;
      adapters = {
        dotnet = {
	  enable = true;
	  settings = {
	    
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

    plugins.coverage = {
      enable = true;
      autoReload = true;
      autoReloadTimeoutMs = 1000;
      lang = {
	dotnet = {
	  coverage_file = "test-results/lcov.info";
	  coverage_command = "just t";
	};
        python = {
	  coverage_file = ".coverage";
	  coverage_command = "coverage json --fail-under=100 -q -o -";
	};
	ruby = {
	  coverage_file = "coverage/coverage.json";
	};
      };
    };

  };
}

