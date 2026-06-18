-- Main plugin spec (loaded via import = "colorscheme_persist.lazyvim").
-- Do not combine import + config on this entry — this file is the config.

return {
  "alexesba/colorscheme-persist.nvim",
  lazy = false,
  opts = {
    restore_on_startup = false,
  },
  init = function(_, opts)
    require("colorscheme_persist").setup(opts)
  end,
  config = function()
    require("colorscheme_persist").setup_commands()
  end,
}
