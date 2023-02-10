local present, bufferline = pcall(require, "bufferline")
if not present then
  return
end

local ctp_present, ctp =
  pcall(require, "catppuccin.groups.integrations.bufferline")
local ctp_bufferline
if not ctp_present then
  ctp_bufferline = {}
else
  ctp_bufferline = ctp.get()
end

local v = vim.version()
local vStr = string.format("v%d.%d.%d", v.major, v.minor, v.patch)

bufferline.setup({
  highlights = ctp_bufferline,
  options = {
    show_close_icon = false,
    show_buffer_close_icons = false,
    offsets = {
      {
        filetype = "NvimTree",
        text = "   neovim " .. vStr,
        text_align = "left",
        separator = "║",
      },
    },
    left_mouse_command = "buffer %d",
    middle_mouse_command = "bdelete! %d",
    right_mouse_command = nil,
    indicator = { icon = "‣" },
    numbers = function(tab)
      local roman = {
        "Ⅰ",
        "Ⅱ",
        "Ⅲ",
        "Ⅳ",
        "Ⅴ",
        "Ⅵ",
        "Ⅶ",
        "Ⅷ",
        "Ⅸ",
        "Ⅹ",
        "Ⅺ",
        "Ⅻ",
        "XⅢ",
        "XⅣ",
        "ⅩⅤ",
        "ⅩⅥ",
        "ⅩⅦ",
        "ⅩⅧ",
        "ⅩⅨ",
        "ⅩⅩ",
      }

      return string.format("%s ", roman[tab.ordinal])
    end,
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
