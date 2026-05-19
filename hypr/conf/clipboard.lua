-- Clipboard history via cliphist (needs wl-clipboard + cliphist installed).

local v = require("conf.variables")

hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm app -- wl-paste --type text  --watch cliphist store")
  hl.exec_cmd("uwsm app -- wl-paste --type image --watch cliphist store")
end)

hl.bind(v.mainMod .. " + R", hl.dsp.exec_cmd(v.rofi_ui_dir .. "/clipboard_menu_ui.sh"))
