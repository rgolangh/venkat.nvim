M = {}

M.config = {}
M.config.pattern = "main.go"
M.config.languages = {
    go = { cmdline = "go run %s", pattern = "main.go" },
    java = { cmdline = "java %s", pattern = "Main.java" },
    rust = { cmdline = "cargo run %s", pattern = "main.rs" },
    python = { cmdline = "python %s", pattern = "main.py" }
}

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
    return cmd
end

M.execute = function()
    local filetype = vim.bo.filetype
    if M.config.languages[filetype] == nil then
        return
    end
    local filename = vim.api.nvim_buf_get_name(0)
    local newcmd = withFilename(filetype, filename)

    local popup = function(bufnr, data)
        if data then
            local floatbuf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_keymap(floatbuf, 'n', '<Esc>', ':close<CR>', {
                silent = true,
                nowait = true,
                noremap = true
            })
            vim.api.nvim_buf_set_lines(floatbuf, 0, 0, false, data)
            vim.api.nvim_open_win(floatbuf, bufnr, {
                relative = "cursor",
                border = "rounded",
                style = "minimal",
                anchor = "NE",
                height = 10,
                width = 80,
                col = 60,
                row = 1,
            })
        end
    end

    local bufnr = vim.api.nvim_get_current_buf()
    vim.fn.jobstart(newcmd, {
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data)
            popup(bufnr, data)
        end,
        on_stderr = function(_, data)
            popup(bufnr, data)
        end,
        on_exit = function(_, data)
        end
    })
end

return M
