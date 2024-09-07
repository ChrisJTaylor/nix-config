{ ... }: {
  
  programs.nixvim = {

    plugins.lsp-format = {
      enable = true;
      lspServersToEnable = [
        "gopls"
        "html"
        "gleam"
        "yamlls"
        "terraformls"
        "bashls"
        "rust-analyzer"
        "kotlin-language-server"
        "lua-ls"
      ];
    };

  };
}

