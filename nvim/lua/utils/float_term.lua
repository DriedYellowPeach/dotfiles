local M = {}

local state = { buf = nil, win = nil, chan = nil, redraw_timer = nil }

local function create_float_opts()
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  return {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
  }
end

local function win_valid()
  return state.win ~= nil and vim.api.nvim_win_is_valid(state.win)
end

function M.setup(_) end

function M.is_available()
  return true
end

function M.get_active_bufnr()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    return state.buf
  end
  return nil
end

function M.open(cmd_string, env_table, _)
  -- Already open: just focus it.
  if win_valid() then
    vim.api.nvim_set_current_win(state.win)
    vim.cmd("startinsert")
    return
  end

  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
    -- Don't render indent guides inside the terminal.
    vim.b[state.buf].miniindentscope_disable = true
  end

  state.win = vim.api.nvim_open_win(state.buf, true, create_float_opts())

  -- Start the terminal only if this buffer isn't already one (reopening
  -- around a still-running terminal just reattaches the window).
  if vim.bo[state.buf].buftype ~= "terminal" then
    local cmd = cmd_string or vim.o.shell

    -- When nvim runs inside tmux, Claude sees $TMUX and wraps its OSC 11
    -- background-color query in a tmux passthrough sequence. But Claude runs
    -- in this nvim :terminal, not directly under tmux, so the passthrough hits
    -- nvim's libvterm and prints a stray "11;?" on first launch. Strip the tmux
    -- env vars so Claude emits a plain OSC 11 query that nvim handles.
    if cmd_string and vim.env.TMUX then
      cmd = "env -u TMUX -u TMUX_PANE " .. cmd_string
    end

    local opts = { term = true }
    if env_table then
      opts.env = env_table
    end
    state.chan = vim.fn.jobstart(cmd, opts)

    -- Double-<Esc> to leave Terminal mode; a single <Esc> passes straight
    -- through to the program (Claude uses it).
    vim.keymap.set("t", "<Esc><Esc>", function()
      vim.cmd("stopinsert")
    end, { buffer = state.buf })

    -- Under a heavy output burst nvim's terminal display lags and the cursor
    -- can sit a row out of place; any redraw (e.g. an outer window resize)
    -- fixes it. Debounce a redraw shortly after output settles so the trailing
    -- frame snaps back, without flicker mid-stream.
    state.redraw_timer = vim.uv.new_timer()
    vim.api.nvim_buf_attach(state.buf, false, {
      on_lines = function()
        if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
          return true -- detach
        end
        if not state.redraw_timer then
          return
        end
        state.redraw_timer:stop()
        state.redraw_timer:start(
          80,
          0,
          vim.schedule_wrap(function()
            if win_valid() then
              vim.cmd("redraw")
            end
          end)
        )
      end,
    })
  end

  vim.cmd("startinsert")
end

function M.close(_, _, _)
  if win_valid() then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
  end
end

function M.kill()
  if state.redraw_timer then
    state.redraw_timer:stop()
    state.redraw_timer:close()
    state.redraw_timer = nil
  end
  if win_valid() then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
  end
  if state.chan then
    vim.fn.jobstop(state.chan)
    state.chan = nil
  end
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
    state.buf = nil
  end
end

function M.simple_toggle(cmd_string, env_table, effective_config)
  if win_valid() then
    M.close(cmd_string, env_table, effective_config)
  else
    M.open(cmd_string, env_table, effective_config)
  end
end

function M.focus_toggle(cmd_string, env_table, effective_config)
  if win_valid() and vim.api.nvim_get_current_win() == state.win then
    M.close(cmd_string, env_table, effective_config)
  else
    M.open(cmd_string, env_table, effective_config)
  end
end

return M
