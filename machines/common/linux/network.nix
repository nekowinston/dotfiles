{
  config,
  lib,
  pkgs,
  ...
}: {
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
      package = lib.mkIf config.isGraphical pkgs.mullvad-vpn;
    };
    stubby = {
      enable = true;
      settings =
        pkgs.stubby.passthru.settingsExample
        // {
          resolution_type = "GETDNS_RESOLUTION_STUB";
          listen_addresses = [
            "127.0.0.1@53000"
            "0::1@53000"
          ];
          upstream_recursive_servers = [
            {
              address_data = "146.255.56.98";
              tls_auth_name = "dot1.applied-privacy.net";
            }
            {
              address_data = "2a01:4f8:c0c:83ed::1";
              tls_auth_name = "dot1.applied-privacy.net";
            }
          ];
        };
    };
  };
}
