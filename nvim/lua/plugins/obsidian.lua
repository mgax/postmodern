return {
  'epwalsh/obsidian.nvim',
  version = '*',
  dependencies = { 'nvim-lua/plenary.nvim' },
  ft = 'markdown',
  opts = {
    workspaces = {
      { name = 'obsidian', path = '~/obsidian' },
    },
    ui = { enable = false },
    follow_url_func = function(url)
      vim.fn.system({ 'open', url })
    end,
    note_id_func = function(title)
      return title and title:lower():gsub('%s+', '-'):gsub('[^%w%-]', '') or ''
    end,
  },
}
