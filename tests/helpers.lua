local M = {}

function M.root()
  return vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
end

function M.temp_state_path()
  local dir = M.root() .. "/.test-state"
  vim.fn.mkdir(dir, "p")
  return dir .. "/" .. vim.fn.tempname():match("([^/]+)$")
end

function M.reload()
  pcall(vim.api.nvim_del_augroup_by_name, "autosave_colorscheme")
  package.loaded["autosave_colorscheme"] = nil
  package.loaded["autosave_colorscheme.config"] = nil
end

function M.read_file(path)
  if vim.fn.filereadable(path) ~= 1 then
    return nil
  end
  return vim.fn.readfile(path)[1]
end

return M
