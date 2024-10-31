{
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
      };
      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "146.255.56.98#dot1.applied-privacy.net"
            "2a01:4f8:c0c:83ed::1#dot1.applied-privacy.net"
          ];
          forward-tls-upstream = true;
        }
      ];
    };
  };
}
