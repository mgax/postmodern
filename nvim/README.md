# neovim config 🪩

Neovim configuration managed by postmodern.

## Languages

- **Python/Django** — ty (type checker/LSP), ruff (linter/formatter)
- **TypeScript/React** — ts_ls
- **Rust** — rust-analyzer
- **HTML/CSS** — treesitter highlighting

## Plugins

| Plugin | Purpose |
|---|---|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configuration |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP server installer |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git gutter marks |
| [catppuccin](https://github.com/catppuccin/nvim) | Color scheme (macchiato/latte) |

## Prerequisites

These are install-on-demand — nvim runs without them and notifies when first needed.

- Treesitter parser compilation: a C compiler (e.g. `apt install build-essential`) and the `tree-sitter` CLI (`cargo install tree-sitter-cli`, or `brew install tree-sitter`).
- ty (Python LSP): `uv tool install ty` (not managed by mason).
- All other language servers are installed automatically by mason on first launch.

## Keybindings

- `<leader>` is `Space`
- `<leader>f` — format current buffer via LSP

## Structure

```
nvim/
  init.lua                  -- entry point, leader key, bootstrap
  lua/plugins/
    catppuccin.lua          -- color scheme
    gitsigns.lua            -- git gutter
    lsp.lua                 -- lspconfig + mason
    treesitter.lua          -- syntax highlighting
```

## To explore later

- File navigation / fuzzy finding (telescope.nvim or fzf-lua)
- More keybindings (add incrementally as needed)
