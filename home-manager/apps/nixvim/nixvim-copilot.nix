{...}: {
  programs.nixvim = {
    plugins.copilot-chat = {
      enable = true;
    };

    plugins.copilot-lua = {
      settings = {
        suggestion = {
          keymap = {
            accept = "<CR>";
            dismiss = "<ESC>";
            next = "<ArrowDown>";
            previous = "<ArrowUp>";
            accept_word = "<Tab>";
            accept_line = "<CR>";
          };
        };
      };
    };
  };
}
