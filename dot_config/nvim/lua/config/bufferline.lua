require("bufferline").setup({
  options = {
    show_close_icon = false,
    separator_style = "slant",
    close_icon = "",
    offsets = { { filetype = "NvimTree" } },
    left_mouse_command = "buffer %d",
    middle_mouse_command = "bdelete! %d",
    right_mouse_command = nil,
  },
})
-- hop between buffers in order of the bar
Nmap("<A-,>", "<Cmd>BufferLineCyclePrev<CR>")
Nmap("<A-.>", "<Cmd>BufferLineCycleNext<CR>")
-- Re-order to previous/next
Nmap("<A-<>", "<Cmd>BufferLineMovePrev<CR>")
Nmap("<A->>", "<Cmd>BufferLineMoveNext<CR>")
-- Goto buffer in position...
Nmap("<A-1>", "<Cmd>BufferLineGoToBuffer 1<CR>")
Nmap("<A-2>", "<Cmd>BufferLineGoToBuffer 2<CR>")
Nmap("<A-3>", "<Cmd>BufferLineGoToBuffer 3<CR>")
Nmap("<A-4>", "<Cmd>BufferLineGoToBuffer 4<CR>")
Nmap("<A-5>", "<Cmd>BufferLineGoToBuffer 5<CR>")
Nmap("<A-6>", "<Cmd>BufferLineGoToBuffer 6<CR>")
Nmap("<A-7>", "<Cmd>BufferLineGoToBuffer 7<CR>")
Nmap("<A-8>", "<Cmd>BufferLineGoToBuffer 8<CR>")
Nmap("<A-9>", "<Cmd>BufferLineGoToBuffer 9<CR>")
Nmap("<A-0>", "<Cmd>BufferLineGoToBuffer -1<CR>")
-- Pin/unpin buffer
Nmap("<A-p>", "<Cmd>BufferLineTogglePin<CR>")
-- Close buffer
Nmap("<A-x>", "<Cmd>bdelete<CR>")
Nmap("<A-X>", "<Cmd>bdelete!<CR>")
-- create new buffer
Nmap("<A-c>", "<Cmd>enew<CR>")
-- pick buffer
Nmap("<A-space>", "<Cmd>BufferLinePick<CR>")
-- Sort automatically by...
Nmap("<Space>bd", "<Cmd>BufferLineSortByDirectory<CR>")
Nmap("<Space>bl", "<Cmd>BufferLineSortByExtension<CR>")
