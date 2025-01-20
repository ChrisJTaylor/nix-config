{ ... }: {
  
  programs.nixvim = {

    plugins.lsp-format = {
      enable = true;
      lspServersToEnable = [
        "javascript"
        "typescript"
        "gopls"
        "python"
        "html"
        "yamlls"
        "terraformls"
        "bashls"
        "rust_analyzer"
        "kotlin_language_server"
        "lua_ls"
        "powershell_es"
        "zls"
      ];
    };

  };
}

