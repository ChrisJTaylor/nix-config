{ ... }: {
  
  programs.nixvim = {

    plugins.coverage = {
      enable = true;
      autoReload = true;
      autoReloadTimeoutMs = 4000;
      commands = true;
      lang = {
	cs = {
	  lcovFile = "test-results/lcov.info";
	};
        python = {
	  lcovFile = "coverage.lcov";
          coverage_command = "poetry run coverage json -q -o -";
	};
	ruby = {
	  coverage_file = "coverage/coverage.json";
	};
	go = {
	  coverage_file = "coverage.out";
	  coverage_command = "coverprofile=coverage.out";
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
        summaryCursorLine = {
          link = "CursorLine";
        };
      };
      keymaps = {
        coverage = "<leader>mc";
        summary = "<leader>mx";
      };
    };

  };
}

