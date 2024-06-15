{ ... }: {
  
  programs.nixvim = {

    plugins.lspsaga = {
      enable = true;
      lightbulb = {
        enable = false;
	virtualText = true;
      };
      symbolInWinbar = {
        enable = true;
	folderLevel = 1;
	showFile = true;
	colorMode = true;
	hideKeyword = false;
      };
      definition = {
        height = 0.5;
        width = 0.6;
      };
      outline = {
        autoPreview = true;
	closeAfterJump = true;
	detail = true;
	autoClose = true;
	layout = "float";
	keys = {
	  jump = "e";
	  quit = "q";
	  toggleOrJump = "o";
	};
      };

    };

  };
}

