-- Core autostart: status bar, polkit agent, idle daemon.

local v = require("conf.variables")

hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm app -- " .. v.status_bar)
  hl.exec_cmd("uwsm app -- hyprpolkitagent")
  hl.exec_cmd("uwsm app -- hypridle -v")
end)
