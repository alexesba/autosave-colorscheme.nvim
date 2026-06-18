# autosave-colorscheme.nvim

Autosave your last Neovim colorscheme and restore it on startup — like VS Code theme persistence.

**Repository:** [github.com/alexesba/autosave-colorscheme.nvim](https://github.com/alexesba/autosave-colorscheme.nvim)

## Features

- Saves your colorscheme whenever it changes
- Restores it on the next startup
- Configurable fallback if the saved theme is missing or fails to load
- Works with LazyVim and plain Neovim setups
- **No picker required** — use `:colorscheme`, Snacks, Telescope, or any switcher you already have

## No picker required (but works with one)

This plugin does **not** include a theme picker. It remembers whatever colorscheme Neovim loads.

| How you switch | Works? |
| --- | --- |
| `:colorscheme tokyonight-night` | Yes |
| LazyVim Snacks (`<leader>uC`) | Yes |
| `:Telescope colorscheme` | Yes |
| fzf-lua, mini.pick, themery.nvim, etc. | Yes, if it applies a colorscheme |

You do not need a picker for this plugin. If you already use one, keep using it.

**Multi-variant themes** (e.g. `ayu-mirage`, `tokyonight-storm`, `catppuccin-mocha`) are saved and restored with the full variant name.

**Single-name themes** (e.g. `sonokai`, `everforest`, `onedark`) may use plugin config for style/flavour — this plugin saves the colorscheme name; set variant options in your colorscheme plugin if needed.

## Requirements

- Neovim 0.9+
- [lazy.nvim](https://github.com/folke/lazy.nvim) (recommended)

## Installation

Add one entry to your lazy.nvim plugins. The `import` line auto-detects LazyVim:

```lua
return {
  {
    "alexesba/autosave-colorscheme.nvim",
    opts = {
      fallback = "tokyonight",
    },
    import = "autosave_colorscheme.import",
  },
}
```

Then run `:Lazy sync` and restart Neovim.

## Usage

### Change your theme

Use any method you like — command, Snacks, Telescope, or another picker:

```vim
:colorscheme sonokai
```

Your choice is saved automatically.

### Restart Neovim

Your last theme is applied on startup.

### Commands

| Command | Action |
| --- | --- |
| `:AutosaveColorscheme restore` | Apply the saved theme now (or fallback) |
| `:AutosaveColorscheme reset` | Clear the saved theme |

To clear the saved file manually:

```bash
rm -f ~/.local/state/nvim/last-colorscheme
```

## Configuration

Pass options via `opts` on your lazy spec:

| Option | Default (LazyVim) | Default (plain Neovim) | Description |
| --- | --- | --- | --- |
| `path` | `stdpath("state")/last-colorscheme` | same | Where the theme name is stored |
| `fallback` | `"default"` | same | Theme to use if restore fails (string or list) |
| `restore_on_startup` | `false` | `true` | Restore on `VimEnter` |
| `lazyvim` | auto | auto | Force LazyVim hook (`true`) or plain mode (`false`) |

Example with multiple fallbacks:

```lua
opts = {
  fallback = { "tokyonight", "habamax", "default" },
},
```

## Troubleshooting

**Theme not saved after I pick one**

- Confirm `import = "autosave_colorscheme.import"` is on your lazy spec.
- Restart Neovim after changing the spec.

**Wrong theme on startup (LazyVim)**

- Check `~/.local/state/nvim/last-colorscheme` contains the theme name you expect.
- Run `:AutosaveColorscheme reset`, pick your theme again, and restart.

**Saved variant wrong (e.g. Ayu Mirage becomes Ayu Dark)**

- Pick the variant again from your picker, or run `:colorscheme ayu-mirage` directly, then restart.

## License

MIT
