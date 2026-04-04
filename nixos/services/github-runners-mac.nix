{
  approved-packages,
  config,
  lib,
  ...
}: let
  runnerNames = [
    "mach-darwin-runner-1"
    "mach-darwin-runner-2"
    "mach-darwin-runner-3"
  ];

  tokenPath = config.sops.secrets.github-runner-token.path;

  # Make each runner daemon wait for the SOPS token file before starting.
  #
  # Root cause: on boot/rebuild, launchd starts all daemons (RunAtLoad = true)
  # concurrently. sops-install-secrets writes /run/secrets/github-runner-token,
  # but the runner daemons can win the race and try to read the token before it
  # exists, failing the configure script immediately.
  #
  # Fix: set KeepAlive.PathState so launchd only launches the runner once the
  # token file is present. The existing WatchPaths already includes the token
  # path, so launchd will kick the runners off naturally the moment SOPS writes
  # the file.
  mkTokenWaitOverride = name: {
    launchd.daemons."github-runner-${name}".serviceConfig.KeepAlive = lib.mkForce {
      PathState = {"${tokenPath}" = true;};
      SuccessfulExit = true;
    };
  };
in {
  imports =
    [
      (import ./github-runner.nix {
        inherit approved-packages;
        name = "mach-darwin-runner-1";
        labels = ["macOS" "ios" "nix-darwin"];
        max-memory = "10G";
      })
      (import ./github-runner.nix {
        inherit approved-packages;
        name = "mach-darwin-runner-2";
        labels = ["macOS" "ios" "nix-darwin" "codeql"];
        max-memory = "10G";
      })
      (import ./github-runner.nix {
        inherit approved-packages;
        name = "mach-darwin-runner-3";
        labels = ["macOS" "ios" "nix-darwin" "codeql"];
        max-memory = "10G";
      })
    ]
    ++ (map mkTokenWaitOverride runnerNames);

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
