# autosave-colorscheme.nvim

Autosave your last Neovim colorscheme and restore it on startup — like VS Code theme persistence.

**Repository:** [github.com/alexesba/autosave-colorscheme.nvim](https://github.com/alexesba/autosave-colorscheme.nvim)

## Features

- Saves the active colorscheme whenever it changes
- Restores the saved theme on startup
- Configurable fallback when the saved theme is missing or fails to load
- One lazy.nvim entry for LazyVim or non-LazyVim setups
- Preloads lazy-loaded colorscheme plugins when [lazy.nvim](https://github.com/folke/lazy.nvim) is present
- **No picker required** — works with `:colorscheme`, existing pickers, or both

## No picker required (but works with one)

This plugin does **not** ship a colorscheme picker. It only listens for the `ColorScheme` event and saves whatever theme Neovim loads.

That means you can change themes however you already like:

| How you switch | Picker needed? | Saved automatically? |
| --- | --- | --- |
| `:colorscheme tokyonight-night` | No | Yes |
| LazyVim Snacks (`<leader>uC`) | Uses your existing Snacks picker | Yes |
| `:Telescope colorscheme` | Uses your existing Telescope setup | Yes |
| fzf-lua, mini.pick, themery.nvim, etc. | Uses whatever you already installed | Yes, if it runs `:colorscheme` |

**You do not need to install or configure a picker for this plugin to work.** If you already have one, keep using it — this plugin sits in the background and remembers your last choice.

### Multi-variant themes

Themes with separate entries in `colors/` (e.g. `ayu-mirage`, `tokyonight-storm`, `catppuccin-mocha`) are saved by their full name (`ev.match`), not just the base `vim.g.colors_name` (`ayu`, `tokyonight`, etc.).

### Single-entry themes with config variants

Some themes only expose one picker entry (e.g. `sonokai`, `everforest`, `onedark`) and control variants via plugin config (`g:sonokai_style`, `require("onedark").setup({ style = "..." })`, etc.). This plugin saves the colorscheme **name**; set style/flavour options in your colorscheme plugin spec if you need a specific variant on restore.

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
    "alexesba/autosave-colorscheme.nvim",
    opts = {
      fallback = "tokyonight",
    },
    import = "autosave_colorscheme.import",
  },
}
```

**Local development:**

```lua
return {
  {
    dir = "~/Projects/autosave-colorscheme.nvim",
    name = "autosave-colorscheme.nvim",
    opts = { fallback = "tokyonight" },
    import = "autosave_colorscheme.import",
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
| `autosave_colorscheme.import` | **Recommended** — auto-detect |
| `autosave_colorscheme.lazyvim` | Always use LazyVim hook |
| `autosave_colorscheme.default` | Never use LazyVim hook |

Then `:Lazy sync` and restart Neovim.

---

## Usage

### Change your theme

Use **any** method that applies a colorscheme. No picker from this plugin is required.

| How | Example | Notes |
| --- | --- | --- |
| Ex command | `:colorscheme sonokai` | Works out of the box |
| LazyVim Snacks | `<leader>uC` | Uses Snacks picker you already have |
| Telescope | `:Telescope colorscheme` | Works if Telescope is in your config |
| Other pickers | themery.nvim, fzf-lua, mini.pick, … | Works as long as they call `:colorscheme` |
| Custom command | `:ColorScheme` | Fine if it ultimately runs `:colorscheme` |

The choice is saved automatically when the `ColorScheme` event fires — regardless of whether you used a picker or typed a command.

### Restart Neovim

Your last theme is restored on startup.

### Commands

| Command | Action |
| --- | --- |
| `:AutosaveColorscheme restore` | Apply saved theme now (or fallback) |
| `:AutosaveColorscheme reset` | Clear saved theme |

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

## Tests

```bash
make test
```

Uses [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) (cloned into `deps/` on first run). Covers save/restore, fallback behavior, and `ColorScheme` autocmd variant persistence (`ev.match`).

---

## Troubleshooting

**Theme not saved after picking in Snacks**

- Use `import = "autosave_colorscheme.import"` (or `.lazyvim` / `.default` manually).
- After startup, `#vim.api.nvim_get_autocmds({ group = "autosave_colorscheme" })` should be `1`.

**Wrong theme on startup (LazyVim)**

- Use `import = "autosave_colorscheme.import"` (auto) or `.lazyvim` explicitly.
- Check `~/.local/state/nvim/last-colorscheme` has the expected name.

---

## License

MIT
