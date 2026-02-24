local parser = require('todo/parser')
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
    return path
end

function M.read_todo_file(path)
    local file = io.open(path, "r")
    local content = file:read("*a")
    file:close()
    return content
end

-- Take the current directory's todo file and return ast
-- Populate state variable with todos
function M.parse(path)
    local contents = M.read_todo_file(path)
    local tasks, biggest_id = parser.parse(contents)
    return tasks, biggest_id
end

function M.add(tasks, id, name)
    table.insert(tasks, parser.Task(id, name, "", "TODO"))
end

function M.serialize(tasks, path)
    local todo_tasks = {}
    local i_tasks = {}
    local d_tasks = {}
    for i, v in ipairs(tasks) do
        if v.status == "TODO" then
            table.insert(todo_tasks, v)
        elseif v.status == "IN-PROGRESS" then
            table.insert(i_tasks, v)
        elseif v.status == "DONE" then
            table.insert(d_tasks, v)
        end
    end

    local final = ""
    final = final .. string.format("TODO:\n")
    for i, v in ipairs(todo_tasks) do
        final = final .. string.format("- [T%d] %s\n", v.id, v.name)
    end
    final = final .. string.format("\nIN-PROGRESS:\n")
    for i, v in ipairs(i_tasks) do
        final = final .. string.format("- [T%d] %s\n", v.id, v.name)
    end
    final = final .. string.format("\nDONE:\n")
    for i, v in ipairs(d_tasks) do
        final = final .. string.format("- [T%d] %s\n", v.id, v.name)
    end

    return final
end

return M
