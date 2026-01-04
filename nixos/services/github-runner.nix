{
  name,
  approved-packages,
}: {config, ...}: {
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
    extraPackages = with approved-packages; [
      nodejs_20
      nodejs_24
      git
      just
      jq
      yq-go
      curl
      gnupg
      gh
    ];
    ephemeral = true;
  };
}
