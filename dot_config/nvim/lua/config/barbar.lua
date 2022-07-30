require("bufferline").setup({
	closable = false,
	icons = "both",
	insert_at_end = true,
	no_name_title = "",
})

-- hop between buffers in order of the bar
Nmap("<A-,>", "<Cmd>BufferPrevious<CR>")
Nmap("<A-.>", "<Cmd>BufferNext<CR>")
-- Re-order to previous/next
Nmap("<A-<>", "<Cmd>BufferMovePrevious<CR>")
Nmap("<A->>", "<Cmd>BufferMoveNext<CR>")
-- Goto buffer in position...
Nmap("<A-1>", "<Cmd>BufferGoto 1<CR>")
Nmap("<A-2>", "<Cmd>BufferGoto 2<CR>")
Nmap("<A-3>", "<Cmd>BufferGoto 3<CR>")
Nmap("<A-4>", "<Cmd>BufferGoto 4<CR>")
Nmap("<A-5>", "<Cmd>BufferGoto 5<CR>")
Nmap("<A-6>", "<Cmd>BufferGoto 6<CR>")
Nmap("<A-7>", "<Cmd>BufferGoto 7<CR>")
Nmap("<A-8>", "<Cmd>BufferGoto 8<CR>")
Nmap("<A-9>", "<Cmd>BufferGoto 9<CR>")
Nmap("<A-0>", "<Cmd>BufferLast<CR>")
-- Pin/unpin buffer
Nmap("<A-p>", "<Cmd>BufferPin<CR>")
-- Close buffer
Nmap("<A-x>", "<Cmd>BufferClose<CR>")
Nmap("<A-X>", "<Cmd>BufferClose!<CR>")
-- create new buffer
Nmap("<A-c>", "<Cmd>enew<CR>")
-- pick buffer
Nmap("<A-space>", "<Cmd>BufferPick<CR>")
-- Sort automatically by...
Nmap("<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>")
Nmap("<Space>bd", "<Cmd>BufferOrderByDirectory<CR>")
Nmap("<Space>bl", "<Cmd>BufferOrderByLanguage<CR>")
Nmap("<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>")
