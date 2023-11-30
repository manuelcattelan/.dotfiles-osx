return {
  "ray-x/lsp_signature.nvim",
  event = "VeryLazy",
  opts = {
    bind = false,
    hint_enable = false,
    floating_window = false,
  },
  config = function(_, opts)
    require("lsp_signature").setup(opts)
  end,
}
