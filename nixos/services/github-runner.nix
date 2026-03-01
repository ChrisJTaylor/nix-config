{
  name,
  labels,
  max-memory,
  approved-packages,
  isLinux ? false,
}: {
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  services.github-runners.${name} = {
    enable = true;
    url = "https://github.com/machinology";
    tokenFile = config.sops.secrets.github-runner-token.path;
    inherit name;
    extraLabels = labels;
    # Use unstable github-runner to avoid deprecated version
    package = inputs.unstable.legacyPackages.${pkgs.system}.github-runner;
    serviceOverrides = lib.optionalAttrs isLinux {
      MemoryMax = max-memory;
    };
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
      cocogitto
      go_1_24
      codeql
    ];
    ephemeral = true;
  };
}
// (lib.optionalAttrs isLinux {
  users.users.github-runner.extraGroups = ["docker"];
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      insecure-registries = [
        "registry.k3s.machinology.internal:30500"
      ];
    };
  };
})
