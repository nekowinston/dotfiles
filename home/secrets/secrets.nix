let
  # yanked from nixpkgs lib
  mapAttrs' =
    f: set: builtins.listToAttrs (builtins.map (attr: f attr set.${attr}) (builtins.attrNames set));

  mkPrefixed = mapAttrs' (
    name: value: {
      name = "home/secrets/" + name;
      inherit value;
    }
  );

  homes = {
    futomaki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAFFAuJa9TYB3IsHly1Z4WjQrr4cEkubNWQyhIClh6bH";
    sashimi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgFwSZPS1B3wndghjmgmamdM5LZ7hqv4fZsbcmYBQWT";
    yuba = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHw8KqsIrn0SMTkBu0qZ5uHNXD0h6hpchTmWt54HhB5Z";
  };
  yubikeys._5ci = "age1yubikey1qfkn095xth4ukxjye98ew4ul6xdkyz7sek0hd67yfjs5z6tv7q9jgnfchls";

  default = [ yubikeys._5ci ] ++ (builtins.attrValues homes);
in
mkPrefixed {
  "aerc-personal.conf.age".publicKeys = default;
  "gitconfig-freelance.age".publicKeys = default;
  "gitconfig-work.age".publicKeys = default;
  "wakatime.cfg.age".publicKeys = default;
}
