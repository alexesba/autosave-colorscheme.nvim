-- Default spec without LazyVim (loaded via import = "autosave_colorscheme.default").

return {
  "alexesba/autosave-colorscheme.nvim",
  lazy = false,
  opts = {
    restore_on_startup = true,
  },
  init = function(_, opts)
    require("autosave_colorscheme").setup(opts)
  end,
  config = function()
    require("autosave_colorscheme").setup_commands()
  end,
}
