if vim.g.loaded_todo then
  return
end

local todo = require("todo")

vim.api.nvim_create_user_command("Todo", function(opts)
  if opts.args == "hello" then
    print("hello world")
  elseif opts.args == "init" then
    print("init")
  end
end, { nargs = 1 })

vim.g.loaded_todo = true
