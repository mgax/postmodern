return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local actions = require('telescope.actions')
    require('telescope').setup({
      defaults = {
        layout_strategy = 'vertical',
        layout_config = { preview_cutoff = 26 },
        mappings = {
          i = { ['<CR>'] = actions.select_tab },
          n = { ['<CR>'] = actions.select_tab },
        },
      },
    })
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<M-p>', builtin.find_files)
    vim.keymap.set('n', '<M-F>', builtin.live_grep)
  end,
}
