let
  homes = {
    futomaki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAFFAuJa9TYB3IsHly1Z4WjQrr4cEkubNWQyhIClh6bH";
    sashimi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIINxJEAR1Ql8bZqKgGmrnxvu5zwz+znis+RZo8jx0o0f";
    yuba = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHw8KqsIrn0SMTkBu0qZ5uHNXD0h6hpchTmWt54HhB5Z";
  };
  yubikeys._5ci = "age1yubikey1qfkn095xth4ukxjye98ew4ul6xdkyz7sek0hd67yfjs5z6tv7q9jgnfchls";

  default = [yubikeys._5ci] ++ (builtins.attrValues homes);
in {
  "home/secrets/aerc-personal.conf.age".publicKeys = default;
  "home/secrets/gitconfig-work.age".publicKeys = default;
  "home/secrets/wakatime.cfg.age".publicKeys = default;
}
