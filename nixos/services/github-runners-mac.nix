{
  config,
  lib,
  approved-packages,
  ...
}: {
  imports = [
    (import ./github-runner.nix {
      inherit approved-packages;
      name = "mach-darwin-runner-1";
      labels = ["macOS" "ios"];
      max-memory = "10G";
    })
    (import ./github-runner.nix {
      inherit approved-packages;
      name = "mach-darwin-runner-2";
      labels = ["macOS" "ios"];
      max-memory = "10G";
    })
    (import ./github-runner.nix {
      inherit approved-packages;
      name = "mach-darwin-runner-3";
      labels = ["macOS" "ios"];
      max-memory = "10G";
    })
  ];

  users.users.github-runner = {
    isSystemUser = true;
    group = "github-runner";
    home = "/var/lib/github-runner";
    createHome = true;
  };

  users.groups.github-runner = {};

  nix.settings.trusted-users = ["github-runner"];

  sops.secrets.github-runner-token = {
    sopsFile = ../../secrets/github-runners.yaml;
  };
}
