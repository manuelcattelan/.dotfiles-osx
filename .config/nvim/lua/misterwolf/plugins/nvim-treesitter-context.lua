return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  enabled = true,
  opts = { mode = "cursor", max_lines = 3 },
  keys = {
    {
      "<leader>tc",
      function()
        local tsc = require("treesitter-context")
        tsc.toggle()
      end,
      desc = "Toggle Treesitter Context",
    },
  },
}
