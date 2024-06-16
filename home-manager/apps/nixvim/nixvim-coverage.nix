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
      };
    };

  };
}

