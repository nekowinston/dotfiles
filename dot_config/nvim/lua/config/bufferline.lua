require("bufferline").setup({
  options = {
    show_close_icon = false,
    separator_style = "slant",
    show_buffer_close_icons = false,
    offsets = { { filetype = "NvimTree" } },
    left_mouse_command = "buffer %d",
    middle_mouse_command = "bdelete! %d",
    right_mouse_command = nil,
  },
})
-- hop between buffers in order of the bar
Map("n", "<A-,>", "<Cmd>BufferLineCyclePrev<CR>")
Map("n", "<A-.>", "<Cmd>BufferLineCycleNext<CR>")
-- Re-order to previous/next
Map("n", "<A-<>", "<Cmd>BufferLineMovePrev<CR>")
Map("n", "<A->>", "<Cmd>BufferLineMoveNext<CR>")
-- Goto buffer in position...
Map("n", "<A-1>", "<Cmd>BufferLineGoToBuffer 1<CR>")
Map("n", "<A-2>", "<Cmd>BufferLineGoToBuffer 2<CR>")
Map("n", "<A-3>", "<Cmd>BufferLineGoToBuffer 3<CR>")
Map("n", "<A-4>", "<Cmd>BufferLineGoToBuffer 4<CR>")
Map("n", "<A-5>", "<Cmd>BufferLineGoToBuffer 5<CR>")
Map("n", "<A-6>", "<Cmd>BufferLineGoToBuffer 6<CR>")
Map("n", "<A-7>", "<Cmd>BufferLineGoToBuffer 7<CR>")
Map("n", "<A-8>", "<Cmd>BufferLineGoToBuffer 8<CR>")
Map("n", "<A-9>", "<Cmd>BufferLineGoToBuffer 9<CR>")
Map("n", "<A-0>", "<Cmd>BufferLineGoToBuffer -1<CR>")
-- Pin/unpin buffer
Map("n", "<A-p>", "<Cmd>BufferLineTogglePin<CR>")
-- Close buffer
Map("n", "<A-x>", "<Cmd>bdelete<CR>")
Map("n", "<A-X>", "<Cmd>bdelete!<CR>")
-- create new buffer
Map("n", "<A-c>", "<Cmd>enew<CR>")
-- pick buffer
Map("n", "<A-space>", "<Cmd>BufferLinePick<CR>")
-- Sort automatically by...
Map("n", "<Space>bd", "<Cmd>BufferLineSortByDirectory<CR>")
Map("n", "<Space>bl", "<Cmd>BufferLineSortByExtension<CR>")
