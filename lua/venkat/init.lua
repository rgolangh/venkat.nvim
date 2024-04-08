M = {}

M.config = {}
M.config.languages = {
    go = { cmdline = "go run %s", pattern = "main.go" },
    java = { cmdline = "java %s", pattern = "Main.java" },
    rust = { cmdline = "cargo -Zscript %s", pattern = "main.rs" },
    python = { cmdline = "python %s", pattern = "main.py" },
    c = { cmdline = "zig run -lc %s", pattern = "main.c" },
    zig = { cmdline = "zig run %s", pattern = "main.zig" },
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
