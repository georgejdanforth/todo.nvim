if vim.g.loaded_todo then
    return
end

local todo = require("todo")

local state = {
    path = nil,
    tasks = {},
    biggest_id = nil
}

-- Detect if file is already initialized in this directory
if vim.fn.filereadable(vim.fs.joinpath(vim.fn.getcwd(), 'todo.txt')) == 1 then
    state.path              = vim.fs.joinpath(vim.fn.getcwd(), 'todo.txt')
    local tasks, biggest_id = todo.parse(state.path)
    state.tasks             = tasks
    state.biggest_id        = biggest_id

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
    elseif opts.fargs[1] == "add" then
        todo.add(state.tasks, "test item")
        todo.serialize(state.tasks, state.path)
    end
end, { nargs = "+" })

vim.g.loaded_todo = true
