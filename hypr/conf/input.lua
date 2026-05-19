-- Keyboard and pointer.
-- follow_mouse = 2: cursor in new window can scroll without stealing focus;
--                   click is required to actually change focus.

hl.config({
  input = {
    kb_layout      = "us",
    repeat_delay   = 200,
    repeat_rate    = 40,
    follow_mouse   = 2,
    natural_scroll = true,
  },
})
