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

      local lspconfig = require('lspconfig')

      -- Mason-managed servers
      lspconfig.ts_ls.setup({})
      lspconfig.rust_analyzer.setup({})
      lspconfig.ruff.setup({})

      vim.lsp.enable('ty')
    end,
  },
}
