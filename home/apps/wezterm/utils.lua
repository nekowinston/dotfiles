---@type wezterm
local wezterm = require("wezterm")
local M = {}

---merge two tables, t2 overwriting t1
---@param t1 table
---@param t2 table
---@return table
M.tableMerge = function(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" then
      if type(t1[k] or false) == "table" then
        M.tableMerge(t1[k] or {}, t2[k] or {})
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
  return t1
end

---check if a table contains a value
---@param t table
---@param val any
---@return boolean
M.tableContains = function(t, val)
  for _, v in ipairs(t) do
    if v == val then
      return true
    end
  end
  return false
end

---check if we're on Linux
---@return boolean
M.is_linux = function()
  return wezterm.target_triple:find("linux") ~= nil
end

---check if we're on macOS
---@return boolean
M.is_darwin = function()
  return wezterm.target_triple:find("darwin") ~= nil
end

return M
