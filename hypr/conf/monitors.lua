-- Logical layout (post-scale, post-transform):
--
--    +---------<2880>------------+  +-<1440>-+
--    |                           |  |        |
--    |      Asus PG32UCDM        |  |        |
--   1620      (DP-3)             |  |        |
--    |                           |  |        |
--    +---------------------------+  |Samsung |
--                                   |S34CG50 |
--                                  3440(DP-4)|
--                                   |vertical|
--                                   |        |
--                                   +--------+
--
-- ASUS PG32UCDM: 4k 240hz
-- For HDR: cm = "hdr", bitdepth = 10, plus sdr/max luminance tuning.

hl.monitor({
	output = "DP-3",
	mode = "3840x2160@240",
	position = "0x0",
	scale = 1.33,
	-- vrr = 1,
	-- cm = "hdr",
	-- bitdepth = 10,
	-- sdrbrightness    = 0.9,
	-- sdrsaturation    = 1.7,
	-- sdr_max_luminance = 300,
	-- max_luminance     = 600,
})

-- Samsung S34CG50 ultrawide, physically mounted in portrait.
-- transform = 3 -> rotated 90 deg counter-clockwise (original right edge is up).
-- Panel is 3440x1440; rotated it occupies 1440x3440 logical pixels.
-- x = 2880 because DP-3 is 3840 / 1.33 = 2880 logical px wide.
-- Panel supports 100Hz; the auto-detected default was only 60Hz.
hl.monitor({
	output = "DP-4",
	mode = "3440x1440@100",
	position = "2880x-1045",
	scale = 1,
	transform = 3,
})

-- Dell secondary (disabled). Re-enable by uncommenting:
-- hl.monitor({ output = "HDMI-A-2", mode = "1920x1080@144", position = "-1080x-200", scale = 1, transform = 1 })

-- Bind workspaces to DP-3
for i = 1, 5 do
	hl.workspace_rule({
		workspace = tostring(i),
		monitor = "DP-3",
		default = (i == 1) or nil,
	})
end

-- Bind workspaces to the vertical DP-4
for i = 6, 10 do
	hl.workspace_rule({
		workspace = tostring(i),
		monitor = "DP-4",
		default = (i == 6) or nil,
	})
end

-- Focus default workspace at login
hl.on("hyprland.start", function()
	hl.dispatch(hl.dsp.focus({ workspace = 1 }))
end)
