-- Define `IEx` command to open scratch file
vim.api.nvim_create_user_command('IEx', function()
  require('iex').open()
end, { desc = 'Open IEx scratch file' })

-- Define `IExRun` command to run scratch file in vsplit
vim.api.nvim_create_user_command('IExRun', function()
  require('iex').run()
end, { desc = 'Run IEx in vsplit' })

-- Aliases to allow both `:IEx` and `:Iex` (hidden from autocomplete)
vim.cmd([[cnoreabbrev <expr> Iex getcmdtype() == ':' && getcmdline() ==# 'Iex' ? 'IEx' : 'Iex']])
vim.cmd([[cnoreabbrev <expr> IexRun getcmdtype() == ':' && getcmdline() ==# 'IexRun' ? 'IExRun' : 'IexRun']])
