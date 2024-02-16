# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, options, ... }:



{

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  environment = {
  # environment.etc
    etc = {
          # use this section to insert items into the etc dir. The keyname is the filename without the /etc/ prepended to the path
    };

    systemPackages = (with pkgs; [
       netbox
    ]);
  };

  users.users = {
    #netbox = {};    # should be created automatically, here so you know where to add additional values
    #
  };

  services.netbox = {
    enable = false;
    secretKeyFile = "/var/lib/netbox/secret-key-file";
    #keycloakdClientSecret = "";
    # mkdir -p /var/lib/netbox/
    # nix-shell -p openssl
    # openssl rand -hex 50 > /var/lib/netbox/secret-key-file
    #
    #
  };


  services.nginx = {
    enable = true;
    user = "netbox";
    recommendedTlsSettings = true;
    clientMaxBodySize = "25m";

    virtualHosts."${config.networking.fqdn}" = {
      locations = {
        "/" = {
          proxyPass = "http://[::1]:8001";
          # proxyPass = "http://${config.services.netbox.listenAddress}:${config.services.netbox.port}";
        };
        "/static/" = { alias = "${config.services.netbox.dataDir}/static/"; };
      };
      forceSSL = true;
      enableACME = true;
      serverName = "${config.networking.fqdn}";
    };
  };

  security.acme = {
    defaults.email = "acme@${config.networking.domain}";
    acceptTerms = true;
  };

}
