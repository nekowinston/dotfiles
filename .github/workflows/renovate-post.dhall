let GithubActions =
      https://github.com/regadas/github-actions-dhall/raw/master/package.dhall
        sha256:9c1ae46a1d56f1c22dbc9006cbb3e569806e75d02fded38fa102935b34980395

let permissions =
      Some
        [ { mapKey = GithubActions.types.Permission.contents
          , mapValue = GithubActions.types.PermissionAccess.write
          }
        ]

let steps =
      [ GithubActions.Step::{ uses = Some "actions/checkout@v4" }
      , GithubActions.Step::{
        , uses = Some "DeterminateSystems/nix-installer-action@v11"
        }
      , GithubActions.Step::{
        , run = Some ../scripts/render-dhall-changes.sh as Text
        }
      , GithubActions.Step::{
        , uses = Some "EndBug/add-and-commit@v9.1.4"
        , `with` = Some
            ( toMap
                { message = "Render Dhall changes"
                , author_name = "renovate[bot]"
                , author_email =
                    "<29139614+renovate[bot]@users.noreply.github.com>"
                }
            )
        }
      ]

let render_dhall_changes =
      GithubActions.Job::{
      , name = Some "Render Dhall changes"
      , runs-on = GithubActions.RunsOn.Type.ubuntu-latest
      , `if` = Some "\${{github.actor == 'renovate[bot]'}}"
      , permissions
      , steps
      }

in  GithubActions.Workflow::{
    , name = "renovate-post"
    , on = GithubActions.On::{
      , push = Some GithubActions.Push::{ branches = Some [ "renovate/*" ] }
      }
    , jobs = toMap { render_dhall_changes }
    }
