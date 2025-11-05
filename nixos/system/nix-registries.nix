{...}: {
  nix.registry.approved-packages = {
    from = {
      id = "approved-packages";
      type = "indirect";
    };
    to = {
      owner = "machinology";
      repo = "mach-approved-packages";
      ref = "main"; # optional, defaults to default branch
      type = "github";
    };
  };
}
