return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    { "<leader>pf", ":lua require'telescope.builtin'.find_files()<CR>", desc = "Project Find (cwd)" },
    { "<leader>pF", ":lua require'telescope.builtin'.git_files()<CR>", desc = "Project Find (gwd)" },
    { "<leader>pg", ":lua require'telescope.builtin'.live_grep()<CR>", desc = "Project Grep (cwd)" },
  },
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<C-i>"] = function(...)
            return require("telescope.actions.layout").toggle_preview(...)
          end,
        },
      },
      layout_config = {
        preview_width = 80,
      },
      borderchars = {
        { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        results = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")

    telescope.setup(opts)
    telescope.load_extension("fzf")
  end,
}
