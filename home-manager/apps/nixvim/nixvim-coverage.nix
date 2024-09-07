{ ... }: {
  
  programs.nixvim = {

    plugins.coverage = {
      enable = true;
      autoReload = true;
      autoReloadTimeoutMs = 1000;
      commands = true;
      lang = {
	cs = {
	  coverage_file = "test-results/lcov.info";
	};
        python = {
	  coverage_file = ".coverage";
	  coverage_command = "coverage json --fail-under=100 -q -o -";
	};
	ruby = {
	  coverage_file = "coverage/coverage.json";
	};
	go = {
	  coverage_file = "coverage/coverage.out";
	  coverage_command = "coverprofile=coverage/coverage.out";
	};
      };
      highlights = {
        covered = {
          fg = "#B7F071";
          bg = "#4a622e";
        };
        partial = {
          fg = "#AA71F0";
          bg = "#452d64";
        };
        uncovered = {
          fg = "#F07178";
          bg = "#6b3237";
        };
      };
      keymaps = {
        coverage = "<A-c>";
        summary = "<A-s>";
      };
    };

  };
}

