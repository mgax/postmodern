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
      if vim.fn.executable('ty') == 1 then
        vim.lsp.enable('ty')
      else
        vim.api.nvim_create_autocmd('FileType', {
          pattern = 'python',
          once = true,
          callback = function()
            vim.notify(
              "ty not on PATH; Python LSP disabled. Install with 'uv tool install ty'.",
              vim.log.levels.INFO
            )
          end,
        })
      end
    end,
  },
}
