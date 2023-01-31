{ config, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  key = "0x0B89BC45007EE9CC";
in

{
  home.packages = with pkgs; [
    git-credential-gopass
    gnupg-pkcs11-scd
    gopass
    gopass-jsonapi
    pcsclite
    pinentry
    yubikey-personalization
  ];

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.configHome}/gnupg";
    scdaemonSettings."disable-ccid" = true;
    settings = {
      # https://github.com/drduh/config/blob/master/gpg.conf
      # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
      # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Esoteric-Options.html
      # Use AES256, 192, or 128 as cipher
      personal-cipher-preferences = "AES256 AES192 AES";
      # Use SHA512, 384, or 256 as digest
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      # Use ZLIB, BZIP2, ZIP, or no compression
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      # Default preferences for new keys
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      # SHA512 as digest to sign keys
      cert-digest-algo = "SHA512";
      # SHA512 as digest for symmetric ops
      s2k-digest-algo = "SHA512";
      # AES256 as cipher for symmetric ops
      s2k-cipher-algo = "AES256";
      # UTF-8 support for compatibility
      charset = "utf-8";
      # Show Unix timestamps
      fixed-list-mode = true;
      # No comments in signature
      no-comments = true;
      # No version in output
      no-emit-version = true;
      # Disable banner
      no-greeting = true;
      # Long hexidecimal key format
      keyid-format = "0xlong";
      # Display UID validity
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      # Display all keys and their fingerprints
      with-fingerprint = true;
      # Display key origins and updates
      with-key-origin = true;
      # Cross-certify subkeys are present and valid
      require-cross-certification = true;
      # Disable caching of passphrase for symmetrical ops
      no-symkey-cache = true;
      # Enable smartcard
      use-agent = true;
      # Disable recipient key ID in messages
      throw-keyids = true;
      # Default/trusted key ID to use (helpful with throw-keyids)
      default-key = key;
      trusted-key = key;
      # Group recipient keys (preferred ID last)
      #group keygroup = 0xFF00000000000001 0xFF00000000000002 0xFF3E7D88647EBCDB
      # Keyserver URL
      keyserver = "hkps://keys.openpgp.org";
      # Verbose output
      #verbose
      # Show expired subkeys
      # list-options = "show-unusable-subkeys";
    };
  };
  services.gpg-agent = {
    enable = isLinux;
    enableExtraSocket = true;
    enableSshSupport = true;
  };
}
