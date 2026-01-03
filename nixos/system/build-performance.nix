{...}: {
  # optimize builder server performance to prevent CPU overload
  # configured for 4-core system (mach-serve-01)

  nix.settings = {
    max-jobs = 3;
    cores = 2;
  };

  # run builds with slightly lower priority
  systemd.services.nix-daemon.serviceConfig = {
    Nice = 5;
    CPUQuote = "85%";
  };
}
