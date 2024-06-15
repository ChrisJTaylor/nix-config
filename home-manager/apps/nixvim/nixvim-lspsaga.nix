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
      };

    };

  };
}

