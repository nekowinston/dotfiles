# use prompt indicators from starship
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = ""

let carapace_completer = {|spans: list<string>|
  if (which carapace | is-empty) { return }

  ^carapace $spans.0 nushell ...$spans
  | from json
  | if ($in | default [] | where value == $"($spans | last)ERR" | is-empty) { $in } else { null }
}

let nix_completer = {|spans: list<string>|
  if (which nix | is-empty) { return }

  let current_arg = $spans | length| $in - 1
  with-env { NIX_GET_COMPLETIONS: $current_arg } { $spans| skip 1| ^nix ...$in }
  | lines
  | skip 1
  | parse "{value}\t{description}"
}

let pwsh_completer = {|spans: list<string>|
  if (which pwsh | is-empty) { return }

  let token = $spans | str join " " | str replace -r "pwsh -(c|Command) " ""
  let cursorColumn = $token | str length

  ^pwsh -c $"[System.Management.Automation.CommandCompletion]::CompleteInput\(\"($token)\", ($cursorColumn), $null).CompletionMatches | Select-Object CompletionText,ToolTip | ConvertTo-Json"
  | from json | default [] | each {|el| {
    value: $el.CompletionText,
    description: $el.ToolTip
  }}
}

let zoxide_completer = {|spans|
  if (which zoxide | is-empty ) { return }

  $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

let external_completer = {|spans|
  let expanded_alias = scope aliases
  | where name == $spans.0
  | get -i 0.expansion

  let spans = if $expanded_alias != null {
    $spans
    | skip 1
    | prepend ($expanded_alias | split row ' ' | take 1)
  } else {
    $spans
  }

  match $spans.0 {
    nix => $nix_completer
    pwsh => $pwsh_completer
    __zoxide_z | __zoxide_zi => $zoxide_completer
    _ => $carapace_completer
  } | do $in $spans
}

$env.config = {
  show_banner: false

  ls: {
    use_ls_colors: true
    clickable_links: true
  }

  rm: { always_trash: false }

  table: {
    mode: psql
    index_mode: auto
    show_empty: true
    padding: { left: 1, right: 1 }
    trim: {
      methodology: truncating
      truncating_suffix: "…"
    }
    header_on_separator: true
    # limit data rows from top and bottom after reaching a set point
    # abbreviated_row_count: 100
  }

  error_style: fancy

  datetime_format: {
    normal: "%Y-%m-%d %I:%M:%S%p"
    table: "%Y-%m-%d %I:%M:%S%p"
  }

  explore: {
    status_bar_background: { fg: "#1D1F21", bg: "#C4C9C6" }
    command_bar_text: { fg: "#C4C9C6" }
    highlight: { fg: "black", bg: "yellow" }
    status: {
      error: { fg: "white", bg: "red" }
      warn: {}
      info: {}
    }
    table: {
      split_line: { fg: "#404040" }
      selected_cell: { bg: light_blue }
      selected_row: {}
      selected_column: {}
    }
  }

  history: {
    max_size: 100_000
    sync_on_enter: true
    file_format: "plaintext"
    isolation: false
  }

  completions: {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "prefix"
    use_ls_colors: true
    external: {
      enable: true
      max_results: 100
      completer: $external_completer
    }
  }

  filesize: {
    metric: false # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
    format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, auto
  }

  cursor_shape: {
    # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (line is the default)
    emacs: inherit
    # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (block is the default)
    vi_insert: inherit
    # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (underscore is the default)
    vi_normal: inherit
  }

  use_grid_icons: true
  # always, never, number_of_rows, auto
  footer_mode: 20
  # the precision for displaying floats in tables
  float_precision: 2
  # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
  # buffer_editor: ""
  use_ansi_coloring: true
  # enable bracketed paste, currently useless on windows
  bracketed_paste: true
  # emacs, vi
  edit_mode: vi
  # enables terminal shell integration. Off by default, as some terminals have issues with this.
  shell_integration: {
    # osc2 abbreviates the path if in the home_dir, sets the tab/window title, shows the running command in the tab/window title
    osc2: true
    # osc7 is a way to communicate the path to the terminal, this is helpful for spawning new tabs in the same directory
    osc7: true
    # osc8 is also implemented as the deprecated setting ls.show_clickable_links, it shows clickable links in ls output if your terminal supports it. show_clickable_links is deprecated in favor of osc8
    osc8: true
    # osc9_9 is from ConEmu and is starting to get wider support. It's similar to osc7 in that it communicates the path to the terminal
    osc9_9: ($env.TERM != "xterm-kitty")
    # osc133 is several escapes invented by Final Term which include the supported ones below.
    # 133;A - Mark prompt start
    # 133;B - Mark prompt end
    # 133;C - Mark pre-execution
    # 133;D;exit - Mark execution finished with exit code
    # This is used to enable terminals to know where the prompt is, the command is, where the command finishes, and where the output of the command is
    osc133: true
    # osc633 is closely related to osc133 but only exists in visual studio code (vscode) and supports their shell integration features
    # 633;A - Mark prompt start
    # 633;B - Mark prompt end
    # 633;C - Mark pre-execution
    # 633;D;exit - Mark execution finished with exit code
    # 633;E - NOT IMPLEMENTED - Explicitly set the command line with an optional nonce
    # 633;P;Cwd=<path> - Mark the current working directory and communicate it to the terminal
    # and also helps with the run recent menu in vscode
    osc633: true
    # reset_application_mode is escape \x1b[?1l and was added to help ssh work better
    reset_application_mode: true
  }

  # true or false to enable or disable right prompt to be rendered on last line of the prompt.
  render_right_prompt_on_last_line: false
  # enables keyboard enhancement protocol implemented by kitty console, only if your terminal support this.
  use_kitty_protocol: (($env.TERM_PROGRAM? == "WezTerm") or ($env.TERM? == "xterm-kitty"))
  # true enables highlighting of external commands in the repl resolved by which.
  highlight_resolved_externals: false
  # the maximum number of times nushell allows recursion before stopping it
  recursion_limit: 50

  hooks: {
    env_change: {
      PWD: [
        {if ((".git" | path exists) and not (which onefetch | is-empty)) {
          onefetch --no-merges --no-bots --no-color-palette --true-color=never --text-colors 1 1 3 4 4
        }}
      ]
    }
    # run to display the output of a pipeline
    display_output: "if (term size).columns >= 100 { table -e } else { table }"
    # return an error message when a command is not found
    command_not_found: { null }
  }
}
