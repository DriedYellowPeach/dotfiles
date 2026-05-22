--    +--<1080>---+
--    |           |
--    |           |
--    |           |  +---------<3840>------------+
--    |           |  2                           |
--    |   Dell    |  1      Asus PG32UCDM        |
--    |           |  6                           |
--    |           |  0                           |
--    |           |  +---------------------------+
--    +-----------+
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

-- Focus default workspace at login
hl.on("hyprland.start", function()
	hl.dispatch(hl.dsp.focus({ workspace = 1 }))
end)
