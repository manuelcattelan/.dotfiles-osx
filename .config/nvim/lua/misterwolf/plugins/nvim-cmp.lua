return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
  },
  opts = function()
    local cmp = require("cmp")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    return {
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
      window = {
        completion = {
          scrollbar = false,
          border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
          winhighlight = "Normal:CmpPmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        },
        documentation = {
          scrollbar = false,
          border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
          winhighlight = "Normal:CmpPmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        },
      },
      experimental = {
        ghost_text = true,
      },
      enabled = function()
        -- disable completion in prompt buffers
        local buffer_type = vim.api.nvim_buf_get_option(0, "buftype")
        if buffer_type == "prompt" then
          return false
        end
        -- disable completion in comments
        local context = require("cmp.config.context")
        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == "c" then
          return true
        else
          return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
        end
      end,
    }
  end,
  config = function(_, opts)
    for _, source in ipairs(opts.sources) do
      source.group_index = source.group_index or 1
    end

    require("cmp").setup(opts)
  end,
}
