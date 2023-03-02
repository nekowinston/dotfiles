{
  lib,
  pkgs,
  ...
}: {
  services = {
    dnsmasq = {
      enable = true;
      servers = [
        "::1#53000"
        "127.0.0.1#53000"
      ];
      extraConfig = ''
        # stubby
        no-resolv
        proxy-dnssec
        listen-address=::1,127.0.0.1

        # loopback for development
        address=/test/127.0.0.1
      '';
    };
    mullvad-vpn = {
      enable = true;
    };
    stubby = {
      enable = true;
      settings = {
        resolution_type = "GETDNS_RESOLUTION_STUB";
        listen_addresses = ["127.0.0.1@53000" "0::1@53000"];
        upstream_recursive_servers = [
          {
            address_data = "194.242.2.3";
            tls_port = 853;
            tls_auth_name = "adblock.doh.mullvad.net";
          }
          {
            address_data = "2a07:e340::3";
            tls_port = 853;
            tls_auth_name = "adblock.doh.mullvad.net";
          }
        ];
      };
    };
  };
}