{...}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        Name = "Christian Taylor";
        email = "christianjtaylor@sky.com";
      };
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
