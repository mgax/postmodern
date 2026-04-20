-- postmodern neovim config 🪩

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.swapfile = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.cursorline = true

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

-- Terminal Cmd-key keymaps (via ghostty escape sequences)
vim.keymap.set({ 'n', 'i' }, '<M-s>', '<cmd>w<cr>')
vim.keymap.set({ 'n', 'i' }, '<M-w>', '<cmd>q<cr>')
vim.keymap.set('n', '<M-/>', 'gcc', { remap = true })
vim.keymap.set('v', '<M-/>', 'gc', { remap = true })
vim.keymap.set({ 'n', 'i' }, '<M-{>', '<cmd>tabprev<cr>')
vim.keymap.set({ 'n', 'i' }, '<M-}>', '<cmd>tabnext<cr>')
vim.keymap.set('n', '<M-t>', '<cmd>tabnew<cr>')

-- General keymaps
vim.keymap.set('n', '<leader>zl', '<cmd>set cursorline!<cr>')
vim.keymap.set('n', '<leader>ce', ':e <C-R>=expand("%:h") . "/" <CR>')
vim.keymap.set('n', '<leader>cte', ':tabe <C-R>=expand("%:h") . "/" <CR>')
vim.keymap.set('n', '<leader>vl', '$BvE')
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end)
vim.keymap.set('n', '<C-S-k>', ':move -2<CR>')
vim.keymap.set('n', '<C-S-j>', ':move +1<CR>')
vim.keymap.set('x', '<C-S-k>', ":move '<-2<CR>gv")
vim.keymap.set('x', '<C-S-j>', ":move '>+1<CR>gv")
vim.keymap.set('n', '<leader>tm', ':tabmove ')
vim.keymap.set('n', '<leader>td', ':tab split<CR>')
vim.keymap.set('n', '<leader>te', ':tabe ')
vim.keymap.set('n', '?', ':nohlsearch<CR>')
vim.keymap.set('i', '<F1>', function() return os.date('%Y-%m-%d') end, { expr = true })
vim.keymap.set('i', '<F2>', function() return os.date('%H:%M') end, { expr = true })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)

-- Recurring tasks
vim.keymap.set('n', '<leader>r', require('recur').recur)

-- Markdown checklist styling
vim.api.nvim_set_hl(0, 'CheckboxDone', { strikethrough = false, fg = '#6c7086' })
vim.api.nvim_set_hl(0, 'CheckboxCancelled', { strikethrough = true, fg = '#6c7086' })
vim.api.nvim_set_hl(0, 'CheckboxImportant', { fg = '#ed8796' })
vim.api.nvim_set_hl(0, 'CheckboxDeferred', { fg = '#6c7086' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.fn.matchadd('CheckboxDone', '- \\[x\\]\\s*\\zs.*')
    vim.fn.matchadd('CheckboxCancelled', '- \\[\\~\\]\\s*\\zs.*')
    vim.fn.matchadd('CheckboxImportant', '- \\[!\\]')
    vim.fn.matchadd('CheckboxDeferred', '- \\[>\\]\\s*\\zs.*')
  end,
})

-- Python keymaps
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.keymap.set('n', '<leader>b', 'obreakpoint()<esc>', { buffer = true })
  end,
})

-- Neovide settings
if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0.03
  vim.g.neovide_cursor_trail_size = 0.3
  vim.g.neovide_scroll_animation_length = 0.2


  vim.keymap.set({ 'n', 'v' }, '<D-c>', '"+y')
  vim.keymap.set({ 'n', 'v', 'i' }, '<D-v>', function() vim.api.nvim_paste(vim.fn.getreg('+'), true, -1) end)
  vim.keymap.set({ 'n', 'i' }, '<D-s>', '<cmd>w<cr>')
  vim.keymap.set({ 'n', 'i' }, '<D-w>', '<cmd>q<cr>')
  vim.keymap.set('n', '<D-/>', 'gcc', { remap = true })
  vim.keymap.set('v', '<D-/>', 'gc', { remap = true })
  vim.keymap.set({ 'n', 'i' }, '<D-{>', '<cmd>tabprev<cr>')
  vim.keymap.set({ 'n', 'i' }, '<D-}>', '<cmd>tabnext<cr>')
  vim.keymap.set('n', '<D-t>', '<cmd>tabnew<cr>')
end
