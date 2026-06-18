--- Auto-detect LazyVim and return the correct lazy.nvim specs.
--- Use: { "alexesba/autosave-colorscheme.nvim", opts = { ... }, import = "autosave_colorscheme.import" }

local function script_dir()
  local src = debug.getinfo(1, "S").source
  return vim.fn.fnamemodify(src:sub(2), ":h")
end

local function load_spec(path)
  local loader = loadfile(path)
  if not loader then
    error("autosave-colorscheme: failed to load " .. path)
  end
  return loader()
end

---@param opts table|nil
local function has_lazyvim(opts)
  if opts and opts.lazyvim ~= nil then
    return opts.lazyvim
  end

  if vim.fn.globpath(vim.fn.stdpath("config"), "lazyvim.json", true, true) ~= "" then
    return true
  end

  local ok, Config = pcall(require, "lazy.core.config")
  if ok and Config.spec and Config.spec.spec then
    for _, s in ipairs(Config.spec.spec) do
      if type(s) == "table" and s[1] == "LazyVim/LazyVim" then
        return true
      end
    end
  end

  return #vim.api.nvim_get_runtime_file("lua/lazyvim/init.lua", false) > 0
end

local dir = script_dir()

if has_lazyvim() then
  local plugin = load_spec(dir .. "/lazyvim/plugin.lua")
  local hook = load_spec(dir .. "/lazyvim/lazyvim.lua")
  return { plugin, hook[1] }
end

return load_spec(dir .. "/default.lua")
