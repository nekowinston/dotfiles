let
  users.winston = "age1yubikey1qfkn095xth4ukxjye98ew4ul6xdkyz7sek0hd67yfjs5z6tv7q9jgnfchls";
  systems.sashimi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIINxJEAR1Ql8bZqKgGmrnxvu5zwz+znis+RZo8jx0o0f";
  default = [users.winston systems.sashimi];
in {
  "home/secrets/aerc-personal.conf.age".publicKeys = default;
  "home/secrets/gitconfig-work.age".publicKeys = default;
  "home/secrets/wakatime.cfg.age".publicKeys = default;
}
