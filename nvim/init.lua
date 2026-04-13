-- postmodern neovim config 🪩

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins')

-- LSP keymaps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)

-- Splash branding
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    vim.defer_fn(function()
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { ' postmodern 🪩 ' })
      local win = vim.api.nvim_open_win(buf, false, {
        relative = 'editor', row = 0, col = 0,
        width = 16, height = 1,
        style = 'minimal', focusable = false,
      })
      vim.defer_fn(function() pcall(vim.api.nvim_win_close, win, true) end, 1000)
    end, 0)
  end,
})
