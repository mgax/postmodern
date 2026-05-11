local parsers = {
  'python', 'typescript', 'tsx', 'javascript',
  'html', 'css', 'rust', 'lua', 'vim', 'vimdoc',
  'markdown', 'markdown_inline',
}

local function has_compiler()
  return vim.fn.executable('cc') == 1
    or vim.fn.executable('gcc') == 1
    or vim.fn.executable('clang') == 1
end

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    if has_compiler() and vim.fn.executable('tree-sitter') == 1 then
      require('nvim-treesitter').install(parsers)
      return
    end

    local warned = false
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        if warned then return end
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then return end
        if pcall(vim.treesitter.language.add, lang) then return end
        warned = true
        vim.notify(
          "treesitter parsers not compiled and 'cc'/'tree-sitter' missing.\n"
            .. 'Install build-essential and tree-sitter-cli for syntax highlighting.',
          vim.log.levels.WARN
        )
      end,
    })
  end,
}
