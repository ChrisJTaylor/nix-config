{approved-packages, ...}: {
  programs.gh = {
    enable = true;

    # Disable automatic credential helper to avoid hardcoded Nix store paths
    gitCredentialHelper.enable = false;

    extensions = with approved-packages; [
      gh-copilot
      gh-f
      gh-cal
    ];

    settings = {};
  };

  # Configure Git credential helper manually with path-agnostic approach
  programs.git.settings = {
    credential."https://github.com" = {
      helper = "!gh auth git-credential";
    };
    credential."https://gist.github.com" = {
      helper = "!gh auth git-credential";
    };
  };

  programs.gh-dash = {
    enable = true;
    settings = {};
  };
}
