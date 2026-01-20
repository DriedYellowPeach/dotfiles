# Neovim Configuration Tips

## How I solve typst project roots setting problem?

By adding `typst.toml`.

## How to use Ctrl+j/k for blink.cmp cmdline completion?

blink.cmp keymaps only apply to default mode by default. Add a `cmdline` section with `preset = "inherit"` to reuse your keymaps:

```lua
cmdline = {
  keymap = {
    preset = "inherit",
  },
},
```
