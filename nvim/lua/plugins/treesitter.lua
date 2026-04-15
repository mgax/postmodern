return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').install({
      'python', 'typescript', 'tsx', 'javascript',
      'html', 'css', 'rust', 'lua', 'vim', 'vimdoc',
      'markdown', 'markdown_inline',
    })
  end,
}
