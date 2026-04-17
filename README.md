# postmodern 🪩

Portable, minimal dev environment across macOS and Linux. Vibe-coded one piece at a time.

- **zsh** — shell config, chained with existing `.zshrc`
- **neovim** — LSP, treesitter, catppuccin, obsidian ([details](nvim/README.md))
- **ghostty** — terminal config with keybinds forwarded to nvim

## Setup

```sh
git clone https://github.com/mgax/postmodern ~/postmodern
uv tool install -e ~/postmodern
postmodern install
postmodern upgrade  # run regularly
```
