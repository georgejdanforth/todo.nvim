local M = {}

function M.parse(contents)
    local todo_start = string.find(contents, "TODO:")
    if not todo_start then
        error({ message = "TODO section not found" })
    end
    local todo_end = todo_start + #"TODO:"

    local in_progress_start = string.find(contents, "IN-PROGRESS:")
    if not in_progress_start then
        error({ message = "IN-PROGRESS section not found" })
    end
    local in_progress_end = in_progress_start + "IN-PROGRESS:"

    local done_start = string.find(contents, "DONE:")
    if not done_start then
        error({ message = "DONE section not found" })
    end
    local done_end = done_start + "DONE:"

    local file_end = #contents

    local todo_section = string.sub(contents, todo_end, in_progress_start)
    local in_progress_section = string.sub(contents, in_progress_end, done_start)
    local done_section = string.sub(contents, done_end, file_end)

    vim.print({
        todo_section = todo_section,
        in_progress_section = in_progress_section,
        done_section = done_section
    })

    return {}
end

return M
