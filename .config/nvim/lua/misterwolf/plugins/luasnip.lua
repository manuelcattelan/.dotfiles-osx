return {
  "L3MON4D3/LuaSnip",
  -- follow latest release.
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  build = "make install_jsregexp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  -- stylua: ignore
  keys = {
    {
      "<C-l>",
      function()
        return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<C-l>"
      end,
      expr = true, silent = true, mode = "i"
    },
    { "<C-l>", function() require("luasnip").jump(1) end, mode = "s", },
    { "<C-h>", function() require("luasnip").jump(-1) end, mode = { "i", "s" }, },
  },
}
