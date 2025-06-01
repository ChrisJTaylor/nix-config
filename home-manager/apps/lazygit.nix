{ ... }: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        nerdFontsVersion = "3";
        showIcons = true;
        border = "rounded";
      };
      os = {
        disableStartupPopups = true;
      };
    };
  };
}
