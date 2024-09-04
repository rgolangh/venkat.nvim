# venkat.nvim
nvim plugin to execute on-save source files and prints back the result in a pop up window.
Release the window with <ESC>.

This plugin is inspired by Venkat Subramanian usage of TextMate in his presentations
and by TJ with his excellent autocmd tutorial.

By default whenever saving a main.go, main.py, main.rs, main.java, nvim will compile and run, and preview 
the result in a floating window.

## Installation

using packer:

```lua
    use('rgolangh/venkat.nvim')
```
using Lazy:

```lua
    return {
        { "rgolangh/venkat.nvim", lazy = false },
    }
```

Here's the default configuration:

```lua
languages = {
    go = { cmdline = "go run %s", pattern = "main.go" },
    java = { cmdline = "java %s", pattern = "Main.java" },
    python = { cmdline = "python %s", pattern = "main.py" },
    rust = { cmdline = "cargo %s", pattern = "main.rs" },
    zig = { cmdline = "zig run %s", pattern = "main.zig" },
}

```

The use of pattern here adheres to nvim's file pattern usage. 
Because executing all the file on save is not usually what you want while developing, a pattern can make this 
more handy. Consider these examples:
```lua
-- all python files under demos a relative demos directory:
    pattern = "*/demos/*.py"
-- all python files under demos a relative demos directory and any main.py:
    pattern = "demos/*.py,main.py"
```

For more info see `:help file-pattern`

If you want to customize the configuration, expand the config in `init.lua` or set this `$HOME/.config/nvim/after/plugin/venkat.lua` :

```lua
require('venkat').setup({
    languages = {
        go = { cmdline = "go run %s", pattern = "demos/*.go,main.go" },
        java = { cmdline = "java %s", pattern = "demos/*.java,Main.java" },
        python = { cmdline = "python %s", pattern = "demos/*.py,main.py" },
        rust = { cmdline = "cargo -Zscript %s", pattern = "main.rs" },
        zig = { cmdline = "zig run %s", pattern = "main.zig" },
        c = { cmdline = "zig run -lc %s", pattern = "main.c" },
}})
```

