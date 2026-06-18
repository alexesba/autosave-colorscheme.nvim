-- LazyVim restore hook (loaded via import = "autosave_colorscheme.lazyvim").

return {
  {
    "LazyVim/LazyVim",
    opts = function()
      local autosave = require("autosave_colorscheme")
      if not autosave.get_saved() then
        return {}
      end
      return {
        colorscheme = function()
          local scheme = autosave.get_saved()
          if scheme and autosave.apply(scheme) then
            return
          end
          autosave.apply_fallback()
        end,
      }
    end,
  },
}
