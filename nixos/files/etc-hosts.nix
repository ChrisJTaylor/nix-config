{...}: {
  environment.etc."hosts".text = ''
    192.168.1.136 cache.machinology.local
  '';
}
