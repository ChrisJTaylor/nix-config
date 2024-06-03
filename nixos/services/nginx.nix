{ ... }:

{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    virtualHosts = {
      jenkins = {
	serverName = "ci.machinology.local";
	serverAliases = [ "ci-static.machinology.local" ];
	forceSSL = false;
	enableACME = false;
	locations = {
	  "/" = {
	    proxyPass = "http://127.0.0.1:8080/";
	  };
	};
      };
    };
  };

}
