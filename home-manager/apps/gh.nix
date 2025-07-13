{pkgs, ...}: {
  programs.gh = {
    enable = true;

    gitCredentialHelper.enable = true;

    extensions = with pkgs; [
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
