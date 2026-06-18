-- Main plugin spec (loaded via import = "autosave_colorscheme.lazyvim").
-- Do not combine import + config on this entry — this file is the config.

return {
  "alexesba/autosave-colorscheme.nvim",
  lazy = false,
  opts = {
    restore_on_startup = false,
  },
  init = function(_, opts)
    require("autosave_colorscheme").setup(opts)
  end,
  config = function()
    require("autosave_colorscheme").setup_commands()
  end,
}
