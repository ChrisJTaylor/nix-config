{name}: {config, ...}: {
  services.github-runners.${name} = {
    enable = true;
    url = "https://github.com/machinology";
    tokenFile = config.sops.secrets.github-runner-token.path;
    inherit name;
    extraLabels = ["nix" "nixos"];
    # Replace the runner if the token changes
    replace = true;
    # Run as a dedicated user
    user = "github-runner";
    nodeRuntimes = [
      "node20"
      "node24"
    ];
    ephemeral = true;
  };
}
