-- Window rules.
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

hl.window_rule({
  name  = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  name  = "fix-xwayland-drags",
  match = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },
  no_focus = true,
})

-- aseprite floats by default; force tiling
hl.window_rule({
  name  = "tile-aseprite",
  match = { class = "(?i)aseprite" },
  float = false,
})

-- hyprland-run launcher: floating, anchored near bottom-left
hl.window_rule({
  name  = "move-hyprland-run",
  match = { class = "hyprland-run" },
  move  = "20 monitor_h-120",
  float = true,
})
