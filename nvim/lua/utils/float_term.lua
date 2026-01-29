local M = {}

local state = { buf = nil, win = nil, chan = nil }

local function create_float_opts()
  local width = math.floor(vim.o.columns * 0.7)
  local height = math.floor(vim.o.lines * 0.9)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  return {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }
end

function M.setup(_)
  -- No setup needed
end

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
  -- If window exists and is valid, focus it
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_set_current_win(state.win)
    vim.cmd("startinsert")
    return
  end

  -- Create buffer if needed
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.b[state.buf].miniindentscope_disable = true
  end

  -- Create floating window
  state.win = vim.api.nvim_open_win(state.buf, true, create_float_opts())

  -- Start terminal if buffer doesn't have one
  if vim.bo[state.buf].buftype ~= "terminal" then
    local cmd = cmd_string or vim.o.shell
    local opts = {}
    if env_table then
      opts.env = env_table
    end
    state.chan = vim.fn.termopen(cmd, opts)
  end

  vim.cmd("startinsert")
end

function M.close(_cmd_string, _env_table, _effective_config)
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
  end
end

function M.simple_toggle(cmd_string, env_table, effective_config)
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    M.close(cmd_string, env_table, effective_config)
  else
    M.open(cmd_string, env_table, effective_config)
  end
end

function M.focus_toggle(cmd_string, env_table, effective_config)
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    if vim.api.nvim_get_current_win() == state.win then
      M.close(cmd_string, env_table, effective_config)
    else
      vim.api.nvim_set_current_win(state.win)
      vim.cmd("startinsert")
    end
  else
    M.open(cmd_string, env_table, effective_config)
  end
end

return M
