{ ... }: {
  
  programs.nixvim = {

    plugins.neo-tree = {
      enable = true;
      enableGitStatus = true;
      enableModifiedMarkers = true;
      enableRefreshOnWrite = true;
      closeIfLastWindow = true;

      buffers = {
        followCurrentFile.enabled = true;
        followCurrentFile.leaveDirsOpen = true;
      };
    };

  };
}
