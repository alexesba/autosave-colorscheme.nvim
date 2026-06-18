-- LazyVim restore hook (loaded via import = "colorscheme_persist.lazyvim").

return {
  {
    "LazyVim/LazyVim",
    opts = function()
      local persist = require("colorscheme_persist")
      if not persist.get_saved() then
        return {}
      end
      return {
        colorscheme = function()
          local scheme = persist.get_saved()
          if scheme and persist.apply(scheme) then
            return
          end
          persist.apply_fallback()
        end,
      }
    end,
  },
}
