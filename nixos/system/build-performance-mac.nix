{...}: {
  # optimize builder server performance to prevent CPU overload
  # configured for 4-core system (mach-serve-01)

  nix.settings = {
    max-jobs = 6;
    cores = 4;
  };

  # run builds with slightly lower priority
  systemd.services.nix-daemon.serviceConfig = {
    Nice = 5;
    CPUQuote = "85%";
  };
}
