{ ... }: {

  programs.nixvim = {

    autoGroups = {
      highlight_yank.clear = true;
    };

    autoCmd = [
      {
        event = [ "TextYankPost" ];
	group = "highlight_yank";
	command = "silent! lua vim.highlight.on_yank{higroup='Search', timeout=200}";
      }

      {
        event = [ "BufWritePost" ];
        pattern = [ "go.mod" ];
        callback = {
          __raw = "function()
              vim.cmd('!go mod tidy')
              vim.lsp.buf.execute_command({ command = 'gopls.workspace.reload' })
            end";
        };
      }
    ];
  };

}
