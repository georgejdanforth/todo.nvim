require("todo")

describe("get_init_path", function()
  it("uses cwd on zero args", function()
    local success, path = pcall(get_init_path)
    assert.equals(success, true)
    assert.equals(vim.fn.getcwd() .. "todo.txt", path)
  end)

  it("uses supplied path when given", function()
    local success, path = pcall(get_init_path, "/tmp")
    assert.equals(success, true)
    assert.equals("/tmp/todo.txt", path)
  end)

  it("returns an error when path is not a dir", function()
    local success, err = pcall(get_init_path, "/foo")
    assert(not success)
    assert.equals("/foo is not a directory", err.message)
  end)
end)

