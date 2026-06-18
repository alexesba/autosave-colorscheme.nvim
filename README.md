# colorscheme-persist.nvim

Persist and restore your last Neovim colorscheme across sessions — like VS Code theme persistence.

No picker bundled. Works with `:colorscheme`, LazyVim (`<leader>uC`), Snacks, Telescope, or any switcher that fires the `ColorScheme` event.

**Repository:** [github.com/alexesba/colorscheme-persist.nvim](https://github.com/alexesba/colorscheme-persist.nvim)

## Features

- Saves the active colorscheme whenever it changes
- Restores the saved theme on startup
- Configurable fallback when the saved theme is missing or fails to load
- One lazy.nvim entry for LazyVim or non-LazyVim setups
- Preloads lazy-loaded colorscheme plugins when [lazy.nvim](https://github.com/folke/lazy.nvim) is present

## Requirements

- Neovim 0.9+
- [lazy.nvim](https://github.com/folke/lazy.nvim) (recommended)

## How it works

1. **Save** — a `ColorScheme` autocmd writes the loaded scheme name (`ev.match`, e.g. `ayu-mirage`) to `~/.local/state/nvim/last-colorscheme`, falling back to `vim.g.colors_name` when needed.
2. **Restore** — on startup, the saved name is applied with `:colorscheme`. If that fails, `fallback` is tried.

---

## Installation & usage

One spec for every setup — `import` auto-detects LazyVim (`lazyvim.json`, `LazyVim/LazyVim` in your lazy spec, or LazyVim on rtp):

```lua
return {
  {
    "alexesba/colorscheme-persist.nvim",
    opts = {
      fallback = "tokyonight",
    },
    import = "colorscheme_persist.import",
  },
}
```

**Local development:**

```lua
return {
  {
    dir = "~/Projects/colorscheme-persist.nvim",
    name = "colorscheme-persist.nvim",
    opts = { fallback = "tokyonight" },
    import = "colorscheme_persist.import",
  },
}
```

### What `import` picks automatically

| Your setup | Loaded specs |
| --- | --- |
| **LazyVim** | Plugin setup + LazyVim restore hook |
| **Plain Neovim** | Plugin setup with `restore_on_startup = true` |

Force a mode with `opts.lazyvim = true` or `opts.lazyvim = false` if auto-detect is wrong.

### Manual imports (optional)

| Import | Use when |
| --- | --- |
| `colorscheme_persist.import` | **Recommended** — auto-detect |
| `colorscheme_persist.lazyvim` | Always use LazyVim hook |
| `colorscheme_persist.default` | Never use LazyVim hook |

Then `:Lazy sync` and restart Neovim.

---

## Usage

### Change your theme

| How | LazyVim | Any setup |
| --- | --- | --- |
| Snacks picker | `<leader>uC` | — |
| Command | `:colorscheme sonokai` | `:colorscheme sonokai` |
| Custom command | `:ColorScheme` (if configured) | — |

The choice is saved automatically when the `ColorScheme` event fires.

### Restart Neovim

Your last theme is restored on startup.

### Commands

| Command | Action |
| --- | --- |
| `:ColorschemePersist restore` | Apply saved theme now (or fallback) |
| `:ColorschemePersist reset` | Clear saved theme |

```bash
rm -f ~/.local/state/nvim/last-colorscheme
```

---

## Configuration

Pass options via `opts` on your lazy spec (merged into `setup()`).

| Option | Default (LazyVim import) | Default (non-LazyVim) | Description |
| --- | --- | --- | --- |
| `path` | `stdpath("state")/last-colorscheme` | same | Persistence file |
| `fallback` | `"default"` | same | One name or list when restore fails |
| `restore_on_startup` | `false` | `true` | Restore on `VimEnter` |
| `lazyvim` | auto | auto | Force LazyVim hook (`true`) or plain mode (`false`) |

Example with multiple fallbacks:

```lua
opts = {
  fallback = { "tokyonight", "habamax", "default" },
},
```

---

## Troubleshooting

**Theme not saved after picking in Snacks**

- Use `import = "colorscheme_persist.import"` (or `.lazyvim` / `.default` manually).
- After startup, `#vim.api.nvim_get_autocmds({ group = "colorscheme_persist" })` should be `1`.

**Wrong theme on startup (LazyVim)**

- Use `import = "colorscheme_persist.import"` (auto) or `.lazyvim` explicitly.
- Check `~/.local/state/nvim/last-colorscheme` has the expected name.

---

## License

MIT
