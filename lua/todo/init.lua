local M = {}

M.config = {
  -- default config options go here
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Template for the TODO list file
local todo_template = [[TODO:

IN-PROGRESS:

DONE:]]

function get_init_path(path)
  if path == nil then
    return vim.fn.getcwd() .. "todo.txt"
  else
    if vim.fn.isdirectory(path) == 1 then
      return vim.fs.joinpath(path, "todo.txt")
    else
      error({ message = path .. " is not a directory" })
    end
  end
end

function M.init()
  local path, err = pcall(get_init_path())
  if err then
    print(err)
    return
  end

end

return M
