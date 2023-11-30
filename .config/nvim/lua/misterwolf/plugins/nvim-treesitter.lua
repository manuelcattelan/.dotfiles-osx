return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })()
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  opts = {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,
    -- List of parsers to ignore installing (or "all")
    ignore_install = {},
    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
    highlight = {
      enable = true,
      -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
      -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
      -- the name of the parser)
      -- list of language that will be disabled
      disable = {},
      -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
      --[[ disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end, ]]
      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "Select outer part of a function definition region" },
          ["if"] = { query = "@function.inner", desc = "Select inner part of a function definition region" },

          ["am"] = { query = "@call.outer", desc = "Select outer part of a function call region" },
          ["im"] = { query = "@call.inner", desc = "Select inner part of a function call region" },

          ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop region" },
          ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop region" },

          ["ac"] = { query = "@conditional.outer", desc = "Select outer part of a conditional region" },
          ["ic"] = { query = "@conditional.inner", desc = "Select inner part of a conditional region" },

          ["ap"] = { query = "@parameter.outer", desc = "Select outer part of a parameter region" },
          ["ip"] = { query = "@parameter.inner", desc = "Select inner part of a parameter region" },

          ["aa"] = { query = "@assignment.outer", desc = "Select outer part of an assignment region" },
          ["ia"] = { query = "@assignment.inner", desc = "Select inner part of an assignment region" },
          ["la"] = { query = "@assignment.lhs", desc = "Select the left hand side of an assignment region" },
          ["ra"] = { query = "@assignment.rhs", desc = "Select the right hand side of an assignment region" },
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]f"] = { query = "@function.outer", desc = "Next function definition start" },
          ["]m"] = { query = "@call.outer", desc = "Next function call start" },
          ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
          ["]c"] = { query = "@conditional.outer", desc = "Next conditional start" },
          ["]p"] = { query = "@parameter.outer", desc = "Next parameter start" },
          ["]a"] = { query = "@assignment.outer", desc = "Next assignment start" },
        },
        goto_next_end = {
          ["]F"] = { query = "@function.outer", desc = "Next function definition end" },
          ["]M"] = { query = "@call.outer", desc = "Next function call end" },
          ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
          ["]C"] = { query = "@conditional.outer", desc = "Next conditional end" },
          ["]P"] = { query = "@parameter.outer", desc = "Next parameter end" },
          ["]A"] = { query = "@assignment.outer", desc = "Next assignment end" },
        },
        goto_previous_start = {
          ["[f"] = { query = "@function.outer", desc = "Previous function definition start" },
          ["[m"] = { query = "@call.outer", desc = "Previous function call start" },
          ["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
          ["[c"] = { query = "@conditional.outer", desc = "Previous conditional start" },
          ["[p"] = { query = "@parameter.outer", desc = "Previous parameter start" },
          ["[a"] = { query = "@assignment.outer", desc = "Previous assignment start" },
        },
        goto_previous_end = {
          ["[F"] = { query = "@function.outer", desc = "Previous function definition end" },
          ["[M"] = { query = "@call.outer", desc = "Previous function call end" },
          ["[L"] = { query = "@loop.outer", desc = "Previous loop end" },
          ["[C"] = { query = "@conditional.outer", desc = "Previous conditional end" },
          ["[P"] = { query = "@parameter.outer", desc = "Previous parameter end" },
          ["[A"] = { query = "@assignment.outer", desc = "Previous assignment end" },
        },
      },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
