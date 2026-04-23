return {
  {
    'williamboman/mason.nvim',
    opts = {},
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    opts = {},
    config = function(_, opts)
      require('mason-lspconfig').setup(opts)
      vim.lsp.enable('ty')
    end,
  },
}
