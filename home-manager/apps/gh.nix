{approved-packages, ...}: {
  programs.gh = {
    enable = true;

    gitCredentialHelper.enable = true;

    extensions = with approved-packages; [
      gh-copilot
      gh-f
      gh-cal
    ];

    settings = {};
  };

  programs.gh-dash = {
    enable = true;
    settings = {};
  };
}
