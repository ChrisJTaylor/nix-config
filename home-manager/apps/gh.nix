{...}: {
  programs.gh = {
    enable = true;

    gitCredentialHelper.enable = true;

    extensions = [
    ];

    settings = {
    };
  };

  programs.gh-dash = {
    enable = true;
    settings = {
    };
  };
}
