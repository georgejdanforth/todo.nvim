local M = {}

local Status = {
    TODO = "TODO",
    DONE = "DONE",
    IN_PROGRESS = "IN-PROGRESS"
}

local Task = function(id, name, description, status)
    return {
        id = id,
        name = name,
        description = description,
        status = status,
    }
end

function M.parse_task_block(status, contents)
    local tasks = {}
    for line in string.gmatch(contents, "([^\r\n]+)") do
        local id, name = string.match(line, "^%- %[(T%d+)%] ([^\r\n]+)")
        tasks[id] = Task(id, name, "", status)
    end
    return tasks
end

function M.parse(contents)
    vim.print(contents)
    local todo_start, todo_end = string.find(contents, "TODO:\n")
    if not todo_start then
        error({ message = "TODO section not found" })
    end
    vim.print(todo_start, todo_end)

    local in_progress_start, in_progress_end = string.find(contents, "IN%-PROGRESS:\n")
    if not in_progress_start then
        error({ message = "IN-PROGRESS section not found" })
    end
    vim.print(in_progress_start, in_progress_end)

    local done_start, done_end = string.find(contents, "DONE:")
    if not done_start then
        error({ message = "DONE section not found" })
    end
    vim.print(done_start, done_end)

    local file_end = #contents

    local todo_section = string.sub(contents, todo_end + 1, in_progress_start - 1)
    local in_progress_section = string.sub(contents, in_progress_end + 1, done_start - 1)
    local done_section = string.sub(contents, done_end + 1, file_end - 1)

    local todo_tasks = M.parse_task_block(Status.TODO, todo_section)
    local in_progress_tasks = M.parse_task_block(Status.IN_PROGRESS, in_progress_section)
    local done_tasks = M.parse_task_block(Status.DONE, done_section)

    local tasks = {}
    tasks = vim.tbl_deep_extend("force", tasks, todo_tasks)
    tasks = vim.tbl_deep_extend("force", tasks, in_progress_tasks)
    tasks = vim.tbl_deep_extend("force", tasks, done_tasks)

    vim.print(tasks)

    -- vim.print({
    --     todo_section = todo_section,
    --     in_progress_section = in_progress_section,
    --     done_section = done_section
    -- })

    return tasks
end

return M
