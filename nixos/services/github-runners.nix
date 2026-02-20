{
  config,
  approved-packages,
  ...
}: {
  imports = [
    (import ./github-runner.nix {
      inherit approved-packages;
      name = "mach-runner-1";
      isLinux = true;
      labels = ["nix" "nixos"];
      max-memory = "10G";
    })
    (import ./github-runner.nix {
      inherit approved-packages;
      name = "mach-runner-2";
      isLinux = true;
      labels = ["nix" "nixos" "codeql"];
      max-memory = "10G";
    })
    (import ./github-runner.nix {
      inherit approved-packages;
      name = "mach-runner-3";
      isLinux = true;
      labels = ["nix" "nixos" "codeql"];
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
