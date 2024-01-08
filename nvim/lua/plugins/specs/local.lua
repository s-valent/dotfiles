local function list_local_plugins()
  local dir = vim.fn.stdpath('config') .. '/lua/plugins/local'
  local contents = vim.fn.system({'ls', dir})
  local specs = {}
  for value in contents:gmatch('[^\n]+') do
    if value ~= 'specs' then
      local path = dir .. '/' .. value
      table.insert(specs, { dir = path })
    end
  end
  return specs
end

return list_local_plugins()
