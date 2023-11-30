return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      typescript = { "eslint_d" },
    },
  },
  config = function(_, opts)
    local lint = require("lint")

    vim.api.nvim_create_autocmd(opts.events, {
      group = vim.api.nvim_create_augroup("augroup_nvim-lint", { clear = true }),
      callback = function()
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)

        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft["_"] or {})
        end

        vim.list_extend(names, lint.linters_by_ft["*"] or {})

        local context = { filename = vim.api.nvim_buf_get_name(0) }
        context.dirname = vim.fn.fnamemodify(context.filename, ":h")
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          if linter then
            return linter and not (type(linter) == "table" and linter.condition and not linter.condition(context))
          end
        end, names)

        if #names > 0 then
          lint.try_lint(names)
        end
      end,
    })
  end,
}
