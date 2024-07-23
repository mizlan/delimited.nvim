# delimited.nvim

Highlight the exact range of a diagnostic!

https://github.com/mizlan/delimited.nvim/assets/44309097/d8d4fac5-036f-4032-99f9-fd762d4f8a4e

Use as a **drop-in replacement** for `vim.diagnostic.goto_next` and
`vim.diagnostic.goto_prev`:

```lua
vim.keymap.set("n", "[d", require("delimited").goto_prev, bufopts)
vim.keymap.set("n", "]d", require("delimited").goto_next, bufopts)
vim.keymap.set("n", "[D", function()
    require("delimited").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, bufopts)
vim.keymap.set("n", "]D", function()
    require("delimited").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, bufopts)
```

You may configure pre- and post-hooks (note that `setup()` is needed if you'd
like to create the default highlights):

```lua
{
    "mizlan/delimited.nvim",
    opts = {
        pre = function()
            -- do something here
        end,
        post = function()
            -- do something here
        end,
    },
},
```

### Highlights

| Group            | Default                      |
|------------------|------------------------------|
| `DelimitedError` | `DiagnosticVirtualTextError` |
| `DelimitedWarn`  | `DiagnosticVirtualTextWarn`  |
| `DelimitedInfo`  | `DiagnosticVirtualTextInfo`  |
| `DelimitedHint`  | `DiagnosticVirtualTextHint`  |
