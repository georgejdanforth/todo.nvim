if vim.g.loaded_todo then
  return
end
vim.g.loaded_todo = true

vim.api.nvim_create_user_command("Todo", function(opts)
  if opts.args == "hello" then
    print("hello world")
  end
end, { nargs = 1 })
