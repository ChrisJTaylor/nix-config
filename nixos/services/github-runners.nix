{
  config,
  lib,
  ...
}: {
  imports = [
    (import ./github-runner.nix {name = "mach-runner-1";})
    (import ./github-runner.nix {name = "mach-runner-2";})
    (import ./github-runner.nix {name = "mach-runner-3";})
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
