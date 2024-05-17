use ($nu.default-config-dir | path join 'config/keybindings.nu')
use ($nu.default-config-dir | path join 'catppuccin.nu')

$env.PROMPT_INDICATOR = {|| "λ " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| "λ " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "$ " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

$env.config = {
  show_banner: false

  ls: {
    use_ls_colors: true
    clickable_links: true
  }

  rm: {
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
      methodology: truncating # `wrapping` or `truncating`
      truncating_suffix: "…"
    }
    # show header text on separator/border line
    header_on_separator: false
    # limit data rows from top and bottom after reaching a set point
    # abbreviated_row_count: 10
  }

  error_style: fancy

  datetime_format: {
    normal: "%Y-%m-%d %I:%M:%S%p"
    table: "%Y-%m-%d %I:%M:%S%p"
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
        columns: 1
        # Optional value. If missing all the screen width is used to calculate column width
        # col_width: 20
        # col_padding: 2
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
  ]
  keybindings: (keybindings)
}
