# delimited.nvim

Use as a drop-in replacement for `vim.diagnostic.goto_next` and
`vim.diagnostic.goto_prev`.

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
