local M = {}

local function fetch_paths(source)
  local filepath = vim.fn.stdpath('config') .. '/' .. source
  local contents = vim.fn.system({'cat', filepath})
  local paths = {}
  for value in contents:gmatch('[^\n]+') do
    local path = vim.fn.resolve(vim.fn.expand(value))
    if path ~= '' then
      table.insert(paths, path)
    end
  end
  return paths
end

M.is_file_valid = function(filename, source)
  local paths = fetch_paths(source)
  for _, path in pairs(paths) do
    if vim.startswith(filename, path) then
        return true
      end
  end
  return false
end

return M
