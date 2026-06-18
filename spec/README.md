# Development

Notes for contributors and local development — not needed for normal installation.

See the [main README](../README.md) for user-facing install and usage.

## Local lazy.nvim spec

Point lazy.nvim at your clone instead of GitHub:

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

Use an absolute path if `~` is not expanded in your environment:

```lua
dir = "/Users/you/Projects/autosave-colorscheme.nvim",
```

**lazy.nvim git check:** a `dir` spec still uses git in that folder. The repo needs at least one commit on `main`, or `:Lazy update` can fail with `branch 'main' not found`.

## How it works (implementation)

1. **Save** — a `ColorScheme` autocmd writes the loaded scheme name (`ev.match`, e.g. `ayu-mirage`) to `~/.local/state/nvim/last-colorscheme`, falling back to `vim.g.colors_name` when needed.
2. **Restore** — on startup, the saved name is applied with `:colorscheme`. If that fails, `fallback` is tried.

## Import modes

| Import | Use when |
| --- | --- |
| `autosave_colorscheme.import` | **Recommended** — auto-detect LazyVim |
| `autosave_colorscheme.lazyvim` | Always use LazyVim restore hook |
| `autosave_colorscheme.default` | Never use LazyVim hook (`restore_on_startup = true`) |

| Your setup | Loaded specs |
| --- | --- |
| **LazyVim** | Plugin setup + LazyVim restore hook |
| **Plain Neovim** | Plugin setup with `restore_on_startup = true` |

## Tests

```bash
make test
```

Uses [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) (cloned into `deps/` on first run). Covers save/restore, fallback behavior, and `ColorScheme` autocmd variant persistence (`ev.match`).

```bash
make clean   # remove deps/ and .test-state/
```

## CI

GitHub Actions runs `make test` on every pull request targeting `main` and on every push to `main` (including after merge). Workflow: [`.github/workflows/ci.yml`](../.github/workflows/ci.yml).

## Debugging

**Verify the save autocmd is registered:**

```vim
:lua print(#vim.api.nvim_get_autocmds({ group = "autosave_colorscheme" }))
```

Should print `1` after startup.

**Check the saved name:**

```bash
cat ~/.local/state/nvim/last-colorscheme
```
