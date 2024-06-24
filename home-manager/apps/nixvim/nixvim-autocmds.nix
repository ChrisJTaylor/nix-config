{ ... }: {

  programs.nixvim = {

    autoGroups = {
      highlight_yank.clear = true;
      coverage_load.clear = true;
      coverage_show.clear = true;
    };

    autoCmd = [
      {
        event = [ "VimEnter" ];
        group = "coverage_load";
	pattern = ["*.py" "*.cs"];
	command = "CoverageLoad";
      }

      {
        event = [ "Filetype" "BufReadPost" "BufWritePost" ];
        group = "coverage_show";
	pattern = ["*.py" "*.cs"];
	command = "CoverageShow";
      }

      {
        event = [ "TextYankPost" ];
	group = "highlight_yank";
	command = "silent! lua vim.highlight.on_yank{higroup='Search', timeout=200}";
      }
    ];
  };

}
