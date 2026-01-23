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
      labels = ["macOS" "ios" "nix-darwin"];
      max-memory = "10G";
    })
    (import ./github-runner.nix {
      inherit approved-packages;
      name = "mach-darwin-runner-2";
      labels = ["macOS" "ios" "nix-darwin"];
      max-memory = "10G";
    })
    (import ./github-runner.nix {
      inherit approved-packages;
      name = "mach-darwin-runner-3";
      labels = ["macOS" "ios" "nix-darwin"];
      max-memory = "10G";
    })
  ];

  users.users.github-runner = {
    uid = 401;
    gid = 401;
    home = "/var/lib/github-runner";
    createHome = true;
  };

  users.knownUsers = ["github-runner"];
  users.knownGroups = ["github-runner"];

  users.groups.github-runner = {
    gid = 401;
  };

  nix.settings.trusted-users = ["github-runner"];

  sops.secrets.github-runner-token = {
    sopsFile = ../../secrets/github-runners.yaml;
    owner = "github-runner";
    group = "github-runner";
    mode = "0400";
  };
}
