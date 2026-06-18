local helpers = require("tests.helpers")

describe("autosave_colorscheme", function()
  local autosave

  before_each(function()
    helpers.reload()
    autosave = require("autosave_colorscheme")
  end)

  describe("config", function()
    it("merges custom options", function()
      local path = helpers.temp_state_path()
      autosave.setup({
        path = path,
        fallback = { "habamax", "default" },
        restore_on_startup = false,
      })

      local cfg = require("autosave_colorscheme.config").get()
      assert.equals(path, cfg.path)
      assert.same({ "habamax", "default" }, cfg.fallback)
      assert.is_false(cfg.restore_on_startup)
    end)
  end)

  describe("save and get_saved", function()
    it("writes and reads the colorscheme name", function()
      local path = helpers.temp_state_path()
      autosave.setup({ path = path, restore_on_startup = false })

      autosave.save("tokyonight-night")
      assert.equals("tokyonight-night", autosave.get_saved())
      assert.equals("tokyonight-night", helpers.read_file(path))
    end)

    it("ignores nil and empty names", function()
      local path = helpers.temp_state_path()
      autosave.setup({ path = path, restore_on_startup = false })

      autosave.save("tokyonight-night")
      autosave.save(nil)
      autosave.save("")

      assert.equals("tokyonight-night", autosave.get_saved())
    end)

    it("returns nil when the state file is missing", function()
      autosave.setup({
        path = helpers.temp_state_path() .. "-missing",
        restore_on_startup = false,
      })

      assert.is_nil(autosave.get_saved())
    end)
  end)

  describe("reset", function()
    it("removes the saved state file", function()
      local path = helpers.temp_state_path()
      autosave.setup({ path = path, restore_on_startup = false })
      autosave.save("gruvbox")
      assert.is_not_nil(autosave.get_saved())

      autosave.reset()
      assert.is_nil(autosave.get_saved())
      assert.equals(0, vim.fn.filereadable(path))
    end)
  end)

  describe("apply and restore", function()
    it("applies a built-in colorscheme", function()
      autosave.setup({ restore_on_startup = false })
      assert.is_true(autosave.apply("default"))
      assert.equals("default", vim.g.colors_name)
    end)

    it("returns false for an unknown colorscheme", function()
      autosave.setup({ restore_on_startup = false })
      assert.is_false(autosave.apply("not-a-real-colorscheme-xyz"))
    end)

    it("restores the saved colorscheme", function()
      local path = helpers.temp_state_path()
      autosave.setup({ path = path, restore_on_startup = false })
      autosave.save("habamax")

      assert.is_true(autosave.restore())
      assert.equals("habamax", vim.g.colors_name)
    end)

    it("falls back when the saved colorscheme cannot load", function()
      local path = helpers.temp_state_path()
      autosave.setup({
        path = path,
        fallback = "default",
        restore_on_startup = false,
      })
      autosave.save("not-a-real-colorscheme-xyz")

      assert.is_true(autosave.restore())
      assert.equals("default", vim.g.colors_name)
    end)

    it("tries fallback entries in order", function()
      autosave.setup({
        fallback = { "not-a-real-colorscheme-xyz", "habamax" },
        restore_on_startup = false,
      })

      assert.is_true(autosave.apply_fallback())
      assert.equals("habamax", vim.g.colors_name)
    end)
  end)

  describe("ColorScheme autocmd", function()
    it("saves ev.match for multi-variant themes", function()
      local path = helpers.temp_state_path()
      autosave.setup({ path = path, restore_on_startup = false })
      autosave.setup_save_autocmd()

      vim.g.colors_name = "ayu"
      vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "ayu-mirage" })

      assert.equals("ayu-mirage", autosave.get_saved())
    end)

    it("falls back to vim.g.colors_name when match is empty", function()
      local path = helpers.temp_state_path()
      autosave.setup({ path = path, restore_on_startup = false })
      autosave.setup_save_autocmd()

      vim.g.colors_name = "tokyonight-night"
      vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "" })

      assert.equals("tokyonight-night", autosave.get_saved())
    end)

    it("registers only one autocmd group", function()
      autosave.setup({ restore_on_startup = false })
      autosave.setup_save_autocmd()
      autosave.setup_save_autocmd()

      local autocmds = vim.api.nvim_get_autocmds({ group = "autosave_colorscheme" })
      assert.equals(1, #autocmds)
    end)
  end)

  describe("lazyvim_spec", function()
    it("returns a LazyVim hook spec", function()
      local path = helpers.temp_state_path()
      local spec = autosave.lazyvim_spec({
        path = path,
        fallback = "default",
        restore_on_startup = false,
      })

      assert.equals("LazyVim/LazyVim", spec[1])
      assert.is_function(spec.opts)
    end)
  end)
end)
