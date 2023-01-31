local present, bufferline = pcall(require, "bufferline")
if not present then
  return
end

bufferline.setup({
  highlights = require("catppuccin.groups.integrations.bufferline").get(),
  options = {
    show_close_icon = false,
    separator_style = "thin",
    show_buffer_close_icons = false,
    offsets = { { filetype = "NvimTree" } },
    left_mouse_command = "buffer %d",
    middle_mouse_command = "bdelete! %d",
    right_mouse_command = nil,
  },
})

local nmap = function(key, cmd)
  vim.api.nvim_set_keymap("n", key, cmd, { noremap = true, silent = true })
end

-- hop between buffers in order of the bar
nmap("<A-,>", "<Cmd>BufferLineCyclePrev<CR>")
nmap("<A-.>", "<Cmd>BufferLineCycleNext<CR>")
-- Re-order to previous/next
nmap("<A-<>", "<Cmd>BufferLineMovePrev<CR>")
nmap("<A->>", "<Cmd>BufferLineMoveNext<CR>")
-- Goto buffer in position...
nmap("<A-1>", "<Cmd>BufferLineGoToBuffer 1<CR>")
nmap("<A-2>", "<Cmd>BufferLineGoToBuffer 2<CR>")
nmap("<A-3>", "<Cmd>BufferLineGoToBuffer 3<CR>")
nmap("<A-4>", "<Cmd>BufferLineGoToBuffer 4<CR>")
nmap("<A-5>", "<Cmd>BufferLineGoToBuffer 5<CR>")
nmap("<A-6>", "<Cmd>BufferLineGoToBuffer 6<CR>")
nmap("<A-7>", "<Cmd>BufferLineGoToBuffer 7<CR>")
nmap("<A-8>", "<Cmd>BufferLineGoToBuffer 8<CR>")
nmap("<A-9>", "<Cmd>BufferLineGoToBuffer 9<CR>")
nmap("<A-0>", "<Cmd>BufferLineGoToBuffer -1<CR>")
-- Pin/unpin buffer
nmap("<A-p>", "<Cmd>BufferLineTogglePin<CR>")
-- Close buffer
nmap("<A-x>", "<Cmd>bdelete<CR>")
nmap("<A-X>", "<Cmd>bdelete!<CR>")
-- create new buffer
nmap("<A-c>", "<Cmd>enew<CR>")
-- pick buffer
nmap("<A-space>", "<Cmd>BufferLinePick<CR>")
-- Sort automatically by...
nmap("<Space>bd", "<Cmd>BufferLineSortByDirectory<CR>")
nmap("<Space>bl", "<Cmd>BufferLineSortByExtension<CR>")
