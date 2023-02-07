switchcmd := if os() == "macos" {
  "darwin-rebuild switch --flake ."
} else if os() == "linux" {
  "nixos-rebuild switch --flake ."
} else {
  "echo 'Unknown OS: {{os()}}'"
}

secret_stage := "git add -f modules/secrets.nix"

secret_unstage := "git restore --staged modules/secrets.nix"

switch:
  {{secret_stage}}
  {{switchcmd}}
  {{secret_unstage}}

home:
  {{secret_stage}}
  home-manager switch --flake .
  {{secret_unstage}}
