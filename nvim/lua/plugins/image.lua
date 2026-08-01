-- Image rendering via the Kitty graphics protocol (snacks.image).
--
-- Draws over nvim's UI straight to the outer terminal, so it needs kitty (or
-- ghostty/wezterm) outside and, under tmux, `allow-passthrough` — see
-- tmux.conf. ImageMagick (`magick`) converts anything that isn't already PNG.
--
-- Note this never works inside nvim's own :terminal: libvterm has no image
-- support at all, so the Claude float can't show images regardless of config.
return {
  {
    "folke/snacks.nvim",
    opts = {
      image = { enabled = true },
    },
  },
}
