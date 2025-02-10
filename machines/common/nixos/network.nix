{ pkgs, ... }:
{
  # to make `dig` & other utils available
  environment.systemPackages = [ pkgs.bind ];

  services.avahi = {
    enable = true;
    # publish the local machines IP
    publish = {
      enable = true;
      addresses = true;
    };
    # resolve .local domains via avahi discovery
    nssmdns4 = true;
    nssmdns6 = true;
  };

  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" ];
        port = 53;
        access-control = [ "127.0.0.1 allow" ];

        hide-identity = true;
        hide-version = true;

        # Based on recommended settings in
        # https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        edns-buffer-size = 1232;
        prefetch = true;
        so-rcvbuf = "1m";
        private-address = [
          "192.168.0.0/16"
          "169.254.0.0/16"
          "172.16.0.0/12"
          "10.0.0.0/8"
          "fd00::/8"
          "fe80::/10"
        ];
      };
      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "9.9.9.9#dns.quad9.net"
            "149.112.112.112#dns.quad9.net"
            "2620:fe::9#dns.quad9.net"
            "2620:fe::fe#dns.quad9.net"
          ];
          forward-tls-upstream = true;
        }
      ];
    };
  };
}
