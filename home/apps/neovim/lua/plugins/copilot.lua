return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<C-J>",
        },
      },
      filetypes = {
        yaml = true,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = "node",
      server_opts_overrides = {},
    },
  },
}
