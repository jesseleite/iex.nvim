local M = {}

-- Default opts config
local config = {
  scratch_file = '.iex.exs',
  output_buf_name = 'iex:///output',
  run_on_save = true,
}

-- Plugin setup
M.setup = function(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  local group = vim.api.nvim_create_augroup('iex_run_on_save', { clear = true })

  if config.run_on_save then
    vim.api.nvim_create_autocmd('BufWritePost', {
      group = group,
      pattern = config.scratch_file,
      callback = M.run,
    })
  end
end

-- Resolve a file path bundled within this plugin's directory
local function resolve_plugin_file(relative_path)
  local found = vim.api.nvim_get_runtime_file(relative_path, false)
  return found and found[1] or nil
end

-- Open the scratch file, creating it from the stub if it doesn't exist
M.open = function()
  local scratch_file = vim.fn.getcwd() .. '/' .. config.scratch_file

  if vim.fn.filereadable(scratch_file) == 0 then
    local stub = resolve_plugin_file('bin/scratch_file_stub.exs')

    if stub then
      vim.uv.fs_copyfile(stub, scratch_file)
    end
  end

  vim.cmd.edit(scratch_file)
end

-- Run the scratch file in a vsplit terminal
M.run = function()
  local current_win = vim.api.nvim_get_current_win()

  -- Check if an iex output window already exists in current tab
  local existing_win = nil
  local existing_buf = nil
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    if name == config.output_buf_name then
      existing_win = win
      existing_buf = buf
      break
    end
  end

  -- Focus existing window, replace its buffer with a fresh one
  -- Or create a new vsplit if one doesn't already exist
  if existing_win and existing_buf and vim.api.nvim_win_is_valid(existing_win) then
    vim.api.nvim_set_current_win(existing_win)
    vim.api.nvim_buf_set_name(existing_buf, '')
    vim.cmd.enew()
    vim.api.nvim_buf_delete(existing_buf, { force = true })
  else
    vim.cmd.vsplit()
  end

  -- Resolve the script runner path from the plugin's bundled files
  local script_runner = resolve_plugin_file('bin/iex_script_runner.exs')
  if not script_runner then
    vim.notify('IEx.nvim: Could not find bin/iex_script_runner.exs', vim.log.levels.ERROR)
    return
  end

  -- Run iex in the terminal buffer and name it for future lookups
  vim.cmd.terminal('mix run ' .. vim.fn.fnameescape(script_runner) .. ' ' .. vim.fn.fnameescape(config.scratch_file))
  vim.api.nvim_buf_set_name(0, config.output_buf_name)

  -- Override window-local statusline to show the full buffer name,
  -- because terminal buftype uses %t which strips the scheme
  vim.wo.statusline = ' ' .. config.output_buf_name .. ' '

  -- Force cursor back to original window
  vim.api.nvim_set_current_win(current_win)
  vim.cmd.stopinsert()
end

return M
