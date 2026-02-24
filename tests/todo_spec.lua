local todo = require("todo")

describe("get_init_path", function()
  it("uses cwd on zero args", function()
    local success, path = pcall(todo.get_init_path)
    assert.equals(success, true)
    assert.equals(vim.fn.getcwd() .. "/" .. "todo.txt", path)
  end)

  it("uses supplied path when given", function()
    local success, path = pcall(todo.get_init_path, "/tmp")
    assert.equals(success, true)
    assert.equals("/tmp/todo.txt", path)
  end)

  it("returns an error when path is not a dir", function()
    local success, err = pcall(todo.get_init_path, "/foo")
    assert(not success)
    assert.equals("/foo is not a directory", err.message)
  end)
end)

describe("M.init", function()
  local test_dir

  before_each(function()
    test_dir = vim.fn.tempname()
    vim.fn.mkdir(test_dir, "p")
  end)

  after_each(function()
    vim.fn.delete(test_dir, "rf")
  end)

  it("initializes the file with the template", function()
    todo.init(test_dir)
    local path = test_dir .. "/todo.txt"
    assert.equals(1, vim.fn.filereadable(path))
    local file = io.open(path, "r")
    local content = file:read("*a")
    file:close()
    assert.equals(todo.todo_template, content)
  end)

  it("doesn't clobber existing TODO file", function()
    local path = test_dir .. "/todo.txt"
    local file, err = io.open(path, "w")
    file:write("foo")
    file:close()
    assert.equals(1, vim.fn.filereadable(path))

    todo.init(test_dir)

    local file = io.open(path, "r")
    local content = file:read("*a")
    file:close()
    assert.equals("foo", content)
  end)
end)
