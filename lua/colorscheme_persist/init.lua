local config = require("colorscheme_persist.config")

local M = {}

local save_augroup = nil

local function preload(scheme)
  pcall(require("lazy.core.loader").colorscheme, scheme)
end

---@return string|nil
function M.get_saved()
  local path = config.get().path
  if vim.fn.filereadable(path) ~= 1 then
    return nil
  end
  local scheme = vim.fn.trim((vim.fn.readfile(path)[1] or ""))
  if scheme == "" then
    return nil
  end
  return scheme
end

---@param name string|nil
function M.save(name)
  if not name or name == "" then
    return
  end
  vim.fn.writefile({ name }, config.get().path, "S")
end

---@param scheme string
---@return boolean
function M.apply(scheme)
  preload(scheme)
  local ok, err = pcall(vim.cmd.colorscheme, scheme)
  if not ok then
    vim.notify(
      ("colorscheme-persist: could not load '%s': %s"):format(scheme, err),
      vim.log.levels.WARN
    )
    return false
  end
  return true
end

---@return boolean
function M.apply_fallback()
  local fb = config.get().fallback
  local list = type(fb) == "table" and fb or { fb }
  for _, scheme in ipairs(list) do
    if M.apply(scheme) then
      return true
    end
  end
  return false
end

---@return boolean
function M.restore()
  local scheme = M.get_saved()
  if scheme and M.apply(scheme) then
    return true
  end
  return M.apply_fallback()
end

function M.reset()
  local path = config.get().path
  if vim.fn.filereadable(path) == 1 then
    vim.fn.delete(path)
  end
end

function M.setup_save_autocmd()
  if save_augroup then
    return
  end
  save_augroup = vim.api.nvim_create_augroup("colorscheme_persist", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = save_augroup,
    callback = function(ev)
      -- ev.match is the :colorscheme argument (e.g. ayu-mirage); vim.g.colors_name
      -- is often the base name only (e.g. ayu) for multi-variant themes.
      local scheme = (ev.match and ev.match ~= "") and ev.match or vim.g.colors_name
      if scheme then
        M.save(scheme)
      end
    end,
  })
end

local restore_registered = false

function M.setup_restore_on_startup()
  if restore_registered or not config.get().restore_on_startup then
    return
  end
  restore_registered = true
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      M.restore()
    end,
  })
end

---@param opts ColorschemePersistConfig|nil
function M.setup(opts)
  config.setup(opts)
  M.setup_save_autocmd()
  M.setup_restore_on_startup()
end

--- LazyVim integration: return a lazy.nvim spec that restores the saved theme on startup.
---@param opts ColorschemePersistConfig|nil
---@return LazyPluginSpec
function M.lazyvim_spec(opts)
  M.setup(opts)
  return {
    "LazyVim/LazyVim",
    opts = function()
      return {
        colorscheme = function()
          local scheme = M.get_saved()
          if scheme and M.apply(scheme) then
            return
          end
          if scheme then
            M.apply_fallback()
          end
        end,
      }
    end,
  }
end

function M.setup_commands()
  vim.api.nvim_create_user_command("ColorschemePersist", function(cmd)
    if cmd.args == "restore" then
      M.restore()
    elseif cmd.args == "reset" then
      M.reset()
      vim.notify("colorscheme-persist: cleared saved colorscheme", vim.log.levels.INFO)
    else
      vim.notify("Usage: :ColorschemePersist restore|reset", vim.log.levels.WARN)
    end
  end, {
    nargs = 1,
    complete = function()
      return { "restore", "reset" }
    end,
    desc = "Restore or reset persisted colorscheme",
  })
end

return M
