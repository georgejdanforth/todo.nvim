local M = {}

M.config = {
  -- default config options go here
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Template for the TODO list file
M.todo_template = [[TODO:

IN-PROGRESS:

DONE:]]

function M.get_init_path(path)
  if path == nil then
    return vim.fs.joinpath(vim.fn.getcwd(), "todo.txt")
  else
    if vim.fn.isdirectory(path) == 1 then
      return vim.fs.joinpath(path, "todo.txt")
    else
      error({ message = path .. " is not a directory" })
    end
  end
end

function M.init(dir)
  local path = M.get_init_path(dir)
  if vim.fn.filereadable(path) == 0 then
    local file, err = io.open(path, "w")
    if not file then
      error({ message = err })
    end
    file:write(M.todo_template)
    file:close()
  end
end

return M
