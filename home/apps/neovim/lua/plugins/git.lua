return {
  "tpope/vim-fugitive",
  {
    "TimUntersberger/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    opts = {
      integrations = {
        diffview = true,
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      local present, wk = pcall(require, "which-key")

      if not present then
        vim.notify("which-key not found")
        return
      end

      local gs = require("gitsigns")

      gs.setup({
        on_attach = function(bufnr)
          -- Gitsigns
          wk.register({
            ["<leader>h"] = {
              name = "+Gitsigns",
              s = { "<cmd>Gitsigns stage_hunk<CR>", "Stage Hunk" },
              r = { "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk" },
            },
          }, { mode = { "n", "v" } })

          wk.register({
            ["<leader>h"] = {
              name = "+Gitsigns",
              s = { gs.stage_buffer, "Stage Buffer" },
              u = { gs.undo_stage_hunk, "Undo Stage Hunk" },
              R = { gs.reset_buffer, "Reset Buffer" },
              p = { gs.preview_hunk, "Preview Hunk" },
              b = {
                function()
                  gs.blame_line({ full = true })
                end,
                "Blame line",
              },
              d = { gs.diffthis, "Diff current buffer" },
              D = {
                function()
                  gs.diffthis("~")
                end,
                "Diff against last commit",
              },
            },
          })

          wk.register({
            ["<leader>t"] = {
              name = "+Toggle settings",
              b = { gs.toggle_current_line_blame, "Toggle blame lines" },
              d = { gs.toggle_deleted, "Toggle deleted lines" },
            },
          })

          wk.register({
            ["[c"] = {
              function()
                if vim.wo.diff then
                  return "]c"
                end
                vim.schedule(function()
                  gs.next_hunk()
                end)
                return "<Ignore>"
              end,
              "Go to Next Hunk",
            },
            ["]c"] = {
              function()
                if vim.wo.diff then
                  return "[c"
                end
                vim.schedule(function()
                  gs.prev_hunk()
                end)
                return "<Ignore>"
              end,
              "Go to Previous Hunk",
            },
          }, { expr = true })

          -- Text object
          wk.register({
            ["ih"] = { ":<C-U>Gitsigns select_hunk<CR>", "Select inside Hunk" },
          }, { mode = { "o", "x" } })
        end,
        signs = {
          add = {
            hl = "GitSignsAdd",
            text = "+",
            numhl = "GitSignsAddNr",
            linehl = "GitSignsAddLn",
          },
          change = {
            hl = "GitSignsChange",
            text = "~",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
          },
          delete = {
            hl = "GitSignsDelete",
            text = "_",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn",
          },
          topdelete = {
            hl = "GitSignsDelete",
            text = "‾",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn",
          },
          changedelete = {
            hl = "GitSignsChange",
            text = "x",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
          },
        },
        linehl = false,
        numhl = false,
        signcolumn = true,
        word_diff = false,
        watch_gitdir = { enable = false, interval = 1000, follow_files = true },
        attach_to_untracked = true,
        -- current line highlighting
        current_line_blame = false,
        current_line_blame_opts = {
          delay = 1000,
          ignore_whitespace = true,
          virt_text = true,
          virt_text_pos = "eol",
        },
        current_line_blame_formatter = "<author>, <author_time:%R> - <summary> | <abbrev_sha>",
        -- perf
        max_file_length = 40000,
        sign_priority = 6,
        update_debounce = 100,
        -- use the included status formatter
        status_formatter = nil,
        preview_config = {
          border = "single",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        yadm = { enable = false },
      })
    end,
  },
}
