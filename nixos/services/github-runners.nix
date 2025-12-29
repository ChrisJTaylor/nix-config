{config, ...}: {
  sops.secrets.github-runner-token = {
    sopsFile = ./secrets/github-runners.yaml;
  };

  services.github-runners = {
    mach-runner-1 = {
      enable = true;
      url = "https://github.com/machinology";
      tokenFile = config.sops.secrets.github-runner-token.path;

      name = "mach-runner-1";

      extraLabels = ["nix" "nixos"];

      # Replace the runner if the token changes
      replace = true;

      # Run as a dedicated user
      user = "github-runner";
    };

    mach-runner-2 = {
      enable = true;
      url = "https://github.com/machinology";
      tokenFile = config.sops.secrets.github-runner-token.path;

      name = "mach-runner-2";

      extraLabels = ["nix" "nixos"];

      # Replace the runner if the token changes
      replace = true;

      # Run as a dedicated user
      user = "github-runner";
    };

    mach-runner-3 = {
      enable = true;
      url = "https://github.com/machinology";
      tokenFile = config.sops.secrets.github-runner-token.path;

      name = "mach-runner-3";

      extraLabels = ["nix" "nixos"];

      # Replace the runner if the token changes
      replace = true;

      # Run as a dedicated user
      user = "github-runner";
    };
  };

  nix.settings.trusted-users = ["github-runner"];
}
