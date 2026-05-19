-- Waybar status bar: keybind + layer blur.

local v = require("conf.variables")

-- Toggle waybar visibility (waybar listens for SIGUSR1).
hl.bind(v.mainMod .. " + B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))

hl.layer_rule({
  name  = "waybar-blur",
  match = { namespace = "waybar" },
  blur         = true,
  ignore_alpha = 0.25,
})
