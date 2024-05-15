let GithubActions =
      https://github.com/regadas/github-actions-dhall/raw/master/package.dhall
        sha256:9c1ae46a1d56f1c22dbc9006cbb3e569806e75d02fded38fa102935b34980395

let NIX_CONFIG =
      ''
      accept-flake-config = true
      extra-experimental-features = flakes nix-command
      ''

let check =
      GithubActions.Job::{
      , runs-on = GithubActions.RunsOn.Type.ubuntu-latest
      , steps =
        [ GithubActions.Step::{ uses = Some "actions/checkout@v4" }
        , GithubActions.Step::{
          , uses = Some "DeterminateSystems/flake-checker-action@v7"
          }
        , GithubActions.Step::{
          , uses = Some "DeterminateSystems/nix-installer-action@v11"
          }
        , GithubActions.Step::{
          , uses = Some "DeterminateSystems/magic-nix-cache-action@v6"
          }
        , GithubActions.Step::{
          , env = Some (toMap { NIX_CONFIG })
          , run = Some "nix flake check --show-trace"
          }
        ]
      }

in  GithubActions.Workflow::{
    , name = "check"
    , on = GithubActions.On::{
      , push = Some GithubActions.Push::{ paths = Some [ "**.nix", "**.lock" ] }
      }
    , jobs = toMap { check }
    }
