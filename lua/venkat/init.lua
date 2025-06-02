M = {}

M.config = {}
M.config.languages = {
    go = { cmdline = "go run %s", pattern = "*/demos/*.go,main.go" },
    java = { cmdline = "java %s", pattern = "*/demos/*.java, main.java" },
    python = { cmdline = "python %s", pattern = "*/demos/*.py,main.py" },
    -- requires Cargo.toml in the target directory or its parent.
    rust = { cmdline = "cargo -Zscript %s", pattern = "main.rs" },
    zig = { cmdline = "zig run -lc -lraylib %s", pattern = "main.zig" },
    c = { cmdline = "zig run -lc %s", pattern = "main.c" },
    js = { cmdline = "node %s", pattern = "main.js" },
    lua = { cmdline = "luajit %s", pattern = "main.lua" },
}

function M.setup(opts)
    opts = opts or {}
    if opts.default then
        error "'default' is not a valid value for setyp . See 'defaults'"
    end

    if opts.languages ~= nil then
        M.config.languages = opts.languages
    end

    vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("venkatmode", { clear = true }),
        pattern = require("venkat").config.getPattern(),
        callback = function()
            require("venkat").execute()
        end,
    })
end

M.config.getPattern = function()
    local pattern = ""
    for _, value in pairs(M.config.languages) do
        pattern = pattern .. "," .. value.pattern
    end
    return pattern
end

local withFilename = function(lang, filename)
    local cmd = {}
    local str = string.format(M.config.languages[lang].cmdline, string.match(filename, "^.+/(.+)$"))
    for i in string.gmatch(str, "%S+") do
        table.insert(cmd, i)
    end

    cmd = {}
    str = string.format(M.config.languages[lang].cmdline, filename)
    for i in string.gmatch(str, "%S+") do
        table.insert(cmd, i)
    end

    --print("cmd is " .. vim.inspect(cmd))
    return cmd
end

M.execute = function()
    --print("executing ... ")
    local filetype = vim.bo.filetype
    if M.config.languages[filetype] == nil then
        return
    end
    local filename = vim.api.nvim_buf_get_name(0)
    local newcmd = withFilename(filetype, filename)
    local floatBufId = vim.api.nvim_create_buf(false, true)
    local windowId = vim.api.nvim_open_win(floatBufId, true, {
        relative = "cursor",
        border = "rounded",
        style = "minimal",
        anchor = "NE",
        height = 10,
        width = 80,
        col = 60,
        row = 1,
    })

    local popup = function(bufnum, data)
        vim.api.nvim_buf_set_keymap(bufnum, 'n', '<Esc>', ':close<CR>', {
            silent = true,
            nowait = true,
            noremap = true

        })
        vim.api.nvim_buf_set_lines(bufnum, -1, -1, false, data)
        vim.api.nvim_set_current_win(windowId)
    end


    vim.fn.jobstart(newcmd, {
        stdout_buffered = false,
        stderr_buffered = false,
        on_stdout = function(_, data)
            popup(floatBufId, data)
        end,
        on_stderr = function(_, data)
            popup(floatBufId, data)
        end,
    })
end

return M
