return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  opts = {
    ensure_installed = {
      "stylua",
    },
    ui = {
      border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
    local mason_registry = require("mason-registry")
    mason_registry:on("package:install:success", function()
      vim.defer_fn(function()
        require("lazy.core.handler.event").trigger({
          event = "FileType",
          buf = vim.api.nvim_get_current_buf(),
        })
      end, 100)
    end)
    local function ensure_installed()
      for _, tool in ipairs(opts.ensure_installed) do
        local mason_package = mason_registry.get_package(tool)
        if not mason_package:is_installed() then
          mason_package:install()
        end
      end
    end
    if mason_registry.refresh then
      mason_registry.refresh(ensure_installed)
    else
      ensure_installed()
    end
  end,
}
