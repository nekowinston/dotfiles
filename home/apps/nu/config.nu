use ($nu.default-config-dir | path join 'config/keybindings.nu')
use ($nu.default-config-dir | path join 'catppuccin.nu')

let carapace_completer = {|spans|
  carapace $spans.0 nushell ...$spans | from json
}

$env.PROMPT_INDICATOR = {|| "λ " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| "λ " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "$ " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

$env.config = {
  show_banner: false

  ls: {
    # use the LS_COLORS environment variable to colorize output
    use_ls_colors: true
    # enable or disable clickable links. Your terminal has to support links.
    clickable_links: true
  }

  rm: {
    # always act as if -t was given. Can be overridden with -p
    always_trash: false
  }

  table: {
    # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
    mode: thin
    # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
    index_mode: auto
    # show 'empty list' and 'empty record' placeholders for command output
    show_empty: true
    # a left right padding of each column in a table
    padding: { left: 1, right: 1 }
    trim: {
      # `wrapping` or `truncating`
      methodology: truncating
      # A strategy used by the 'wrapping' methodology
      wrapping_try_keep_words: true
      # A suffix used by the 'truncating' methodology
      truncating_suffix: "…"
    }
    # show header text on separator/border line
    header_on_separator: false

    # limit data rows from top and bottom after reaching a set point
    # abbreviated_row_count: 10
  }

  error_style: "fancy" # "fancy" or "plain" for screen reader-friendly error messages

  # datetime_format determines what a datetime rendered in the shell would look like.
  # Behavior without this configuration point will be to "humanize" the datetime display,
  # showing something like "a day ago."
  datetime_format: {
    # shows up in displays of variables or other datetime's outside of tables
    # normal: '%a, %d %b %Y %H:%M:%S %z'

    # generally shows up in tabular outputs such as ls. commenting this out will change it to the default human readable datetime format
    table: '%Y-%m-%d %I:%M:%S%p'
  }

  explore: {
    status_bar_background: { fg: "#1D1F21", bg: "#C4C9C6" },
    command_bar_text: { fg: "#C4C9C6" },
    highlight: { fg: "black", bg: "yellow" },
    status: {
      error: { fg: "white", bg: "red" },
      warn: {}
      info: {}
    },
    table: {
      split_line: { fg: "#404040" },
      selected_cell: { bg: light_blue },
      selected_row: {},
      selected_column: {},
    },
  }

  history: {
    # Session has to be reloaded for this to take effect
    max_size: 100_000
    # Enable to share history between multiple sessions, else you have to close the session to write history to file
    sync_on_enter: true
    # "sqlite" or "plaintext"
    file_format: "plaintext"
    # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
    isolation: false
  }

  completions: {
    # set to true to enable case-sensitive completions
    case_sensitive: false
    # set this to false to prevent auto-selecting completions when only one remains
    quick: true
    # set this to false to prevent partial filling of the prompt
    partial: true
    # prefix or fuzzy
    algorithm: "prefix"
    external: {
      # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up may be very slow
      enable: true
      # setting it lower can improve completion performance at the cost of omitting some options
      max_results: 100
      # check 'carapace_completer' above as an example
      completer: $carapace_completer
    }
    use_ls_colors: true # set this to true to enable file/path/directory completions using LS_COLORS
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

  color_config: (catppuccin "mocha")
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
  shell_integration: ($env.TERM_PROGRAM == "WezTerm")
  # true or false to enable or disable right prompt to be rendered on last line of the prompt.
  render_right_prompt_on_last_line: false
  # enables keyboard enhancement protocol implemented by kitty console, only if your terminal support this.
  use_kitty_protocol: ($env.TERM_PROGRAM == "WezTerm")
  # true enables highlighting of external commands in the repl resolved by which.
  highlight_resolved_externals: false
  # the maximum number of times nushell allows recursion before stopping it
  recursion_limit: 50

  hooks: {
    env_change: {
      PWD: [
        {if (".git" | path exists) {
          onefetch --no-merges --no-bots --no-color-palette --text-colors 1 1 3 4 4
        }}
      ]
    }
    # run to display the output of a pipeline
    display_output: "if (term size).columns >= 100 { table -e } else { table }"
    # return an error message when a command is not found
    command_not_found: { null }
  }

  menus: [
    # Configuration for default nushell menus
    # Note the lack of source parameter
    {
      name: completion_menu
      only_buffer_difference: false
      marker: "| "
      type: {
        layout: columnar
        columns: 4
        # Optional value. If missing all the screen width is used to calculate column width
        col_width: 20
        col_padding: 2
      }
      style: {
        text: green
        selected_text: { attr: r }
        description_text: yellow
        match_text: { attr: u }
        selected_match_text: { attr: ur }
      }
    }
    {
      name: ide_completion_menu
      only_buffer_difference: false
      marker: "| "
      type: {
        layout: ide
        min_completion_width: 0,
        max_completion_width: 50,
        max_completion_height: 10, # will be limited by the available lines in the terminal
        padding: 0,
        border: true,
        cursor_offset: 0,
        description_mode: "prefer_right"
        min_description_width: 0
        max_description_width: 50
        max_description_height: 10
        description_offset: 1
        # If true, the cursor pos will be corrected, so the suggestions match up with the typed text
        #
        # C:\> str
        #      str join
        #      str trim
        #      str split
        correct_cursor_pos: false
      }
      style: {
        text: green
        selected_text: { attr: r }
        description_text: yellow
        match_text: { attr: u }
        selected_match_text: { attr: ur }
      }
    }
    {
      name: history_menu
      only_buffer_difference: true
      marker: "? "
      type: {
        layout: list
        page_size: 10
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
    }
    {
      name: help_menu
      only_buffer_difference: true
      marker: "? "
      type: {
        layout: description
        columns: 4
        col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
        col_padding: 2
        selection_rows: 4
        description_rows: 10
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
    }
  ]
  keybindings: (keybindings)
}
