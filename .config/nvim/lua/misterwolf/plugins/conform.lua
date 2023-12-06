local slow_filetype_formatting = {}

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  keys = {
    {
      "<leader>ff",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      typescript = { "prettierd" },
      rust = { "rustfmt" },
      sql = { "sqlfluff" },
    },
    format_on_save = function(buffer_number)
      if slow_filetype_formatting[vim.bo[buffer_number].filetype] then
        return
      end
      local function format_or_skip(error)
        if error and error:match("timeout$") then
          slow_filetype_formatting[vim.bo[buffer_number].filetype] = true
        end
      end
      return { timeout_ms = 200, lsp_fallback = true }, format_or_skip
    end,
    format_after_save = function(buffer_number)
      if not slow_filetype_formatting[vim.bo[buffer_number].filetype] then
        return
      end
      return { lsp_fallback = true }
    end,
  },
  config = function(_, opts)
    require("conform").setup(opts)
  end,
}
