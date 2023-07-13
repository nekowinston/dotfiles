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
    mullvad-vpn.enable = true;
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
  networking.stevenblack = {
    enable = true;
    block = ["fakenews" "gambling"];
  };
  networking.hostFiles = [
    "${pkgs.runCommand "stevenblack-hosts-custom" {} ''
      mkdir -p $out
      grep -zoiP "#\s?(facebook|instagram|reddit|twitter|tiktok|whatsapp)\n[\d.\w\s-]*" \
        ${pkgs.stevenblack-blocklist}/alternates/social/hosts \
        > $out/hosts
    ''}/hosts"
  ];
}
