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

function M.parse_task_block(status, contents, tasks)
    local biggest_id = 0
    for line in string.gmatch(contents, "([^\r\n]+)") do
        local id, name = string.match(line, "^%- %[T(%d+)%] ([^\r\n]+)")
        id = tonumber(id)
        if id > biggest_id then
            biggest_id = id
        end
        table.insert(tasks, Task(id, name, "", status))
    end
    return biggest_id
end

function M.parse(contents)
    vim.print(contents)
    local todo_start, todo_end = string.find(contents, "TODO:\n")
    if not todo_start then
        error({ message = "TODO section not found" })
    end

    local in_progress_start, in_progress_end = string.find(contents, "IN%-PROGRESS:\n")
    if not in_progress_start then
        error({ message = "IN-PROGRESS section not found" })
    end

    local done_start, done_end = string.find(contents, "DONE:")
    if not done_start then
        error({ message = "DONE section not found" })
    end

    local file_end = #contents

    local todo_section = string.sub(contents, todo_end + 1, in_progress_start - 1)
    local in_progress_section = string.sub(contents, in_progress_end + 1, done_start - 1)
    local done_section = string.sub(contents, done_end + 1, file_end - 1)

    local tasks = {}
    local biggest_id = math.max(
        M.parse_task_block(Status.TODO, todo_section, tasks),
        M.parse_task_block(Status.IN_PROGRESS, in_progress_section, tasks),
        M.parse_task_block(Status.DONE, done_section, tasks)
    )

    return tasks, biggest_id
end

return M
