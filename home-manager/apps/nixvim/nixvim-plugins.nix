{ ... }: {

  programs.nixvim = {

    clipboard.providers.xclip.enable = true;

    plugins.lightline.enable = true;
    plugins.which-key.enable = true;

    plugins.refactoring.enable = true;
    plugins.refactoring.enableTelescope = true;

  };

}
