# venkat.nvim
nvim plugin to execute on save main source files

This plugin is inspired by Venkat Subramanian usage of TextMate in his Presentations
and by TJ with his excellent autocmd tutorial.

By default whenever saving a main.go, main.py, main.rs, main.java, nvim will compile and run, and preview 
the result in a floating window.

Here's the default configuration:

```lua
require('venkat').config.languages = {
    go = { cmdline = "go run %s", pattern = "main.go" },
    java = { cmdline = "java %s", pattern = "Main.java" },
    python = { cmdline = "python %s", pattern = "main.py" },
    rust = { cmdline = "cargo run %s", pattern = "main.rs" },
    zig = { cmdline = "zig run %s", pattern = "main.zig" },
}
```

Install using packer:

```lua
    use('rgolangh/venkat.nvim')
```

Expand the config in `init.lua`:

```
require('venkat').config.languages = {
    go = { cmdline = "go run %s", pattern = "main.go" },
    java = { cmdline = "java %s", pattern = "Main.java" },
    python = { cmdline = "python %s", pattern = "main.py" },
    rust = { cmdline = "cargo run %s", pattern = "main.rs" },
    zig = { cmdline = "zig run %s", pattern = "main.zig" },
    c = { cmdline = "zig run %s", pattern = "main.c" },
}

```

