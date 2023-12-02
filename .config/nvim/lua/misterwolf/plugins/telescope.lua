return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    {
      "<leader>pf",
      function()
        require("telescope.builtin").find_files({ hidden = true })
      end,
      desc = "Project Find (cwd)",
    },
    {
      "<leader>pF",
      function()
        require("telescope.builtin").git_files({ show_untracked = true })
      end,
      desc = "Project Find (gwd)",
    },
    {
      "<leader>pg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Project Grep (cwd)",
    },
    {
      "<leader>pG",
      function()
        local function is_inside_git_project()
          vim.fn.system("git rev-parse --is-inside-work-tree")
          return vim.v.shell_error == 0
        end

        local function get_git_project_root()
          local git_project_root = vim.fn.finddir(".git", ".;")
          return vim.fn.fnamemodify(git_project_root, ":h")
        end

        local opts = {}
        if is_inside_git_project() then
          opts = { cwd = get_git_project_root() }
        end

        require("telescope.builtin").live_grep(opts)
      end,
      desc = "Project Grep (gwd with fallback)",
    },
  },
  opts = function()
    local telescopeConfig = require("telescope.config")

    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
    local file_ignore_patterns = { ".git/", "node_modules/*" }

    table.insert(vimgrep_arguments, "--hidden")
    table.insert(vimgrep_arguments, "--glob")
    table.insert(vimgrep_arguments, "!**/.git/*")

    return {
      defaults = {
        vimgrep_arguments = vimgrep_arguments,
        file_ignore_patterns = file_ignore_patterns,
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
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")

    telescope.setup(opts)
    telescope.load_extension("fzf")
  end,
}
