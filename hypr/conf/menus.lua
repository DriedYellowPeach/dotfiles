-- Rofi-based menus: window rules, layer blur, keybindings.

local v = require("conf.variables")

local menu        = v.rofi_ui_dir .. "/app_menu_ui.sh"
local powermenu   = v.rofi_ui_dir .. "/power_menu_ui.sh"
local windowmenu  = v.rofi_ui_dir .. "/window_menu_ui.sh"

-- Rofi window rules (for rofi -normal-window mode)
hl.window_rule({
  name  = "rofi-rules",
  match = { class = "^(Rofi)$" },
  border_size = 0,
  animation   = "popin",
})

-- Rofi layer: blur with ignore_alpha
hl.layer_rule({
  name  = "rofi-blur",
  match = { namespace = "rofi" },
  blur         = true,
  ignore_alpha = 0.25,
})

hl.bind(v.mainMod .. " + escape", hl.dsp.exec_cmd(powermenu))
hl.bind(v.mainMod .. " + SPACE",  hl.dsp.exec_cmd(menu))
hl.bind(v.mainMod .. " + Tab",    hl.dsp.exec_cmd(windowmenu))
