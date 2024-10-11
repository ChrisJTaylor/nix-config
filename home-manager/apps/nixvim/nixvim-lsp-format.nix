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
        "kotlin-language-server"
        "lua-ls"
        "powershell_es"
      ];
    };

  };
}

