{ ... }: {

  programs.nixvim = {

    autoCmd = [

      {
        event = [ "VimEnter" ];
	pattern = ["*.cs"];
	command = ":lua vim.fn.system('just t')";
      }

      {
        event = [ "BufWritePost" ];
	pattern = ["*.cs"];
	command = ":lua vim.fn.system('just t')";
      }
      
      {
        event = [ "Filetype" ];
	pattern = ["*.py"];
	command = ":CoverageShow";
      }

      {
        event = [ "BufEnter" "WinEnter" ];
	pattern = ["*.cs"];
	command = ":CoverageLoadLcov test-results/lcov.info";
      }

      {
        event = [ "BufWinEnter" ];
	pattern = ["*.cs"];
	command = ":CoverageShow";
      }

      {
        event = [ "TextYankPost" ];
	group = "highlight_yank";
	command = "silent! lua vim.highlight.on_yank{higroup='Search', timeout=200}";
      }
    ];
    autoGroups.highlight_yank.clear = true;
  };

}
