-- Default spec without LazyVim (loaded via import = "colorscheme_persist.default").

return {
  "alexesba/colorscheme-persist.nvim",
  lazy = false,
  opts = {
    restore_on_startup = true,
  },
  init = function(_, opts)
    require("colorscheme_persist").setup(opts)
  end,
  config = function()
    require("colorscheme_persist").setup_commands()
  end,
}
