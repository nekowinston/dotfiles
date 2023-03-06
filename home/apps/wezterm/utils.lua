local M = {}

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

M.tableContains = function(t, val)
  for _, v in ipairs(t) do
    if v == val then
      return true
    end
  end

  return false
end

return M
