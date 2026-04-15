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
    opts = {
      ensure_installed = {
        'ts_ls',
        'rust_analyzer',
        'ruff',
      },
    },
    config = function(_, opts)
      require('mason-lspconfig').setup(opts)
      vim.lsp.enable({ 'ts_ls', 'rust_analyzer', 'ruff', 'ty' })
    end,
  },
}
