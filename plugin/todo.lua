if vim.g.loaded_todo then
    return
end

local todo = require("todo")

local state = {
    path = nil,
    tasks = {}
}

-- Detect if file is already initialized in this directory
if vim.fs.filereadable(vim.fs.joinpath(vim.fn.cwd(), 'todo.txt')) == 1 then
    state.path = vim.fs.joinpath(vim.fn.cwd(), 'todo.txt')
    state.tasks = M.parse(state.path)
    print(state)
    vim.print(state)
end

vim.api.nvim_create_user_command("Todo", function(opts)
    if opts.args == "hello" then
        print("hello world")
    elseif opts.fargs[1] == "init" then
        local success, result = pcall(todo.init, opts.fargs[2])
        if not success then
            vim.print(result.message)
        end
        if state == nil then
            state.path = result
        end
    end
end, { nargs = "+" })

vim.g.loaded_todo = true
