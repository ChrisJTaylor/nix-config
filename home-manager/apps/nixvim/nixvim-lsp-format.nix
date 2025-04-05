{ ... }: {
  
  programs.nixvim = {

    plugins.lsp-format = {
      enable = true;
      lspServersToEnable = [
        "omnisharp"
        "gleam"
        "ts_ls"
        "gopls"
        "pylsp"
        "html"
        "yamlls"
        "terraformls"
        "bashls"
        "nil_ls"
        "rust_analyzer"
        "kotlin_language_server"
        "lua_ls"
        "powershell_es"
        "nushell"
        "zls"
      ];
    };

  };
}

