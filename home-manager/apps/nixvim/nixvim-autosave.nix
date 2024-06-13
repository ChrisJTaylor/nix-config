{ ... }: {

  programs.nixvim = {

    plugins.auto-save = {
      enable = true;
      enableAutoSave = true;
      triggerEvents = [
        "InsertLeave"
	"TextChanged"
	"FocusLost"
      ];
      writeAllBuffers = true;
      executionMessage = {
        dim = 0.50;
	cleaningInterval = 1250;
	message = {
	  __raw = ''
	    function()
	      return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
	    end
	 '';
	};
      };
    };

  };

}

