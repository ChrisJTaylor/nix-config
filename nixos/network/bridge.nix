{ ... }:

{
  networking = {
    useNetworkd = true;
    useDHCP = false;

    bridges = {
      br0 = {
        interfaces = [ "enp7s0f0" ];
      };
    };

    interfaces = {
      br0 = {
        useDHCP = true;
        ipv4.addresses = [{ address = "10.0.100.3"; prefixLength = 8; }];
      };
    };

  };
}
