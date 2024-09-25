{ ... }: {
  
  programs.nixvim = {

    plugins.lsp-format = {
      enable = true;
      lspServersToEnable = [
        "gopls"
        "python"
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

