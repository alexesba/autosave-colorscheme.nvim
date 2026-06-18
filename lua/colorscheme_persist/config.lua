local M = {}

---@class ColorschemePersistConfig
---@field path string
---@field fallback string|string[]
---@field restore_on_startup boolean restore saved theme on VimEnter (set false when using LazyVim import)

---@type ColorschemePersistConfig
local defaults = {
  path = vim.fn.stdpath("state") .. "/last-colorscheme",
  fallback = "default",
  restore_on_startup = true,
}

M._config = vim.deepcopy(defaults)

---@param opts ColorschemePersistConfig|nil
function M.setup(opts)
  M._config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
end

---@return ColorschemePersistConfig
function M.get()
  return M._config
end

return M
