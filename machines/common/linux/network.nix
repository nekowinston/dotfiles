{pkgs, ...}: {
  services = {
    dnsmasq = {
      enable = true;
      settings = {
        # stubby
        no-resolv = true;
        proxy-dnssec = true;
        listen-address = "::1,127.0.0.1";
        server = [
          "::1#53000"
          "127.0.0.1#53000"
        ];
        # loopback for development
        address = "/test/127.0.0.1";
      };
    };
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    stubby = {
      enable = true;
      settings = {
        resolution_type = "GETDNS_RESOLUTION_STUB";
        listen_addresses = ["127.0.0.1@53000" "0::1@53000"];
        upstream_recursive_servers = [
          {
            address_data = "146.255.56.98";
            tls_port = 853;
            tls_auth_name = "dot1.applied-privacy.net";
          }
        ];
      };
    };
  };
}
