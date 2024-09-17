{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Christian Taylor";
    userEmail = "christianjtaylor@sky.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };
}
