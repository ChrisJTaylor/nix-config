{...}: {
  programs.git = {
    enable = true;
    userName = "Christian Taylor";
    userEmail = "christianjtaylor@sky.com";
    extraConfig = {
      diff.tool = "bc3";
      difftool.bc3.cmd = ''bcompare "$LOCAL" "$REMOTE"'';

      merge.tool = "bc3";
      mergetool.bc3.cmd = ''bcompare "$LOCAL" "$REMOTE" "$BASE" "$MERGED"'';
      mergetool.bc3.trustExitCode = true;

      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };
}
