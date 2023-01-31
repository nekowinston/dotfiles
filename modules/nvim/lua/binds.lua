function map(mode, shortcut, command, opt)
  opt = opt or { noremap = true, silent = true }
  vim.keymap.set(mode, shortcut, command, opt)
end

-- easier split navigation
map("n", "<C-J>", "<C-W>j")
map("n", "<C-K>", "<C-W>k")
map("n", "<C-L>", "<C-W>l")
map("n", "<C-H>", "<C-W>h")
map("n", "<C-W>\\", ":vsplit<CR>")
map("n", "<C-W>-", ":split<CR>")
map("n", "<C-W>x", ":q<CR>")
-- merge conflicts
map("n", "gd", ":diffget")
map("n", "gdh", ":diffget //2<CR>")
map("n", "gdl", ":diffget //3<CR>")
-- escape :terminal easier
map("t", "<Esc>", "<C-\\><C-n>")
-- keep cursor in the middle when scrolling and searching
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- NvimTree
map("n", "<C-N>", ":NvimTreeToggle<CR>")
