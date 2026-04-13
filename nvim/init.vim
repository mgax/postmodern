" postmodern neovim config 🪩

autocmd VimEnter * ++once lua vim.defer_fn(function()
  \ local buf = vim.api.nvim_create_buf(false, true)
  \ vim.api.nvim_buf_set_lines(buf, 0, -1, false, {' postmodern 🪩 '})
  \ local win = vim.api.nvim_open_win(buf, false, {
  \   relative = 'editor', row = 0, col = 0,
  \   width = 16, height = 1,
  \   style = 'minimal', focusable = false,
  \ })
  \ vim.defer_fn(function() pcall(vim.api.nvim_win_close, win, true) end, 1000)
  \ end, 0)
