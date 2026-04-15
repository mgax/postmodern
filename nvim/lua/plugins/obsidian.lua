return {
  'epwalsh/obsidian.nvim',
  version = '*',
  dependencies = { 'nvim-lua/plenary.nvim' },
  ft = 'markdown',
  opts = {
    workspaces = {
      { name = 'obsidian', path = '~/obsidian' },
    },
  },
}
