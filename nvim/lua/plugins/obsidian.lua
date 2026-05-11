return {
  'epwalsh/obsidian.nvim',
  version = '*',
  dependencies = { 'nvim-lua/plenary.nvim' },
  ft = 'markdown',
  opts = function()
    local mappings = require("obsidian.config").MappingOpts.default()
    mappings["<S-CR>"] = {
      action = function()
        require("obsidian.util").toggle_checkbox({ "~", "x", ">", "!", " " })
      end,
      opts = { buffer = true, desc = "Cycle checkbox backwards" },
    }
    return {
      workspaces = {
        { name = 'obsidian', path = '~/obsidian' },
      },
      ui = {
        enable = false,
        -- Toggle order; char/hl_group are unused since ui is disabled (defaults from obsidian/config.lua)
        checkboxes = {
          [" "] = { order = 1, char = "󰄱", hl_group = "ObsidianTodo" },
          ["!"] = { order = 2, char = "", hl_group = "ObsidianImportant" },
          [">"] = { order = 3, char = "", hl_group = "ObsidianRightArrow" },
          ["x"] = { order = 4, char = "", hl_group = "ObsidianDone" },
          ["~"] = { order = 5, char = "󰰱", hl_group = "ObsidianTilde" },
        },
      },
      mappings = mappings,
      follow_url_func = function(url)
        vim.fn.system({ 'open', url })
      end,
      note_id_func = function(title)
        if not title or title == '' then return '' end
        local s = vim.fn.tolower(title)
        s = vim.fn.substitute(s, '\\s\\+', '-', 'g')
        s = vim.fn.substitute(s, '[^[:keyword:]-]\\+', '', 'g')
        return s
      end,
    }
  end,
}
