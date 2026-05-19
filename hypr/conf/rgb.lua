-- OpenRGB server + initial profile load.

local v = require("conf.variables")

hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm app -s b -- openrgb --server")
  hl.exec_cmd(v.hypr_dir .. "/scripts/rgb-init.sh")
end)
