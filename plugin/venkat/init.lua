--vim.api.nvim_create_autocmd("BufWritePost", {
--    group = vim.api.nvim_create_augroup("venkatmode", { clear = true }),
--    pattern = require("venkat").config.getPattern(),
--    callback = function()
--        require("venkat").execute()
--    end,
--})



