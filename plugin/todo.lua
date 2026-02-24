if vim.g.loaded_todo then
  return
end

local todo = require("todo")

vim.api.nvim_create_user_command("Todo", function(opts)
  if opts.args == "hello" then
    print("hello world")
  elseif opts.fargs[1] == "init" then
    local success, result = pcall(todo.init, opts.fargs[2])
    if not success then
      vim.print(result.message)
    end
  end
end, { nargs = "+" })

vim.g.loaded_todo = true
