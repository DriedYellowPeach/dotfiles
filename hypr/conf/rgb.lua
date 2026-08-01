-- OpenRGB server + initial profile load.

-- One process, not two: openrgb detects hardware, applies the profile, then
-- starts the server -- in that order. Applying from a second process races
-- detection, and a client that starts before the server is up silently falls
-- back to its own hardware detection instead of failing.
hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm app -s b -- openrgb --server --config /home/neil/.config/OpenRGB --profile us")
end)
