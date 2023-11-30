local function try_window_jump(jump_direction, jump_count)
  local previous_window_number = vim.fn.winnr()
  vim.cmd(jump_count .. "wincmd " .. jump_direction)
  return vim.fn.winnr() ~= previous_window_number
end

local function try_window_jump_with_wrap(intended_jump_direction, opposite_direction)
  local jump_count = vim.v.count1
  return function()
    if not try_window_jump(intended_jump_direction, jump_count) then
      try_window_jump(opposite_direction, 999)
    end
  end
end

local function map(mode, key, command, options)
  options = options or {}
  options.silent = options.silent ~= false
  options.noremap = options.noremap ~= true
  vim.keymap.set(mode, key, command, options)
end

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Window navigation
map("n", "<leader>w", "<cmd>only<CR>", { desc = "Close all other windows" })
map("n", "<C-h>", try_window_jump_with_wrap("h", "l"), { desc = "Jump to window (right)" })
map("n", "<C-j>", try_window_jump_with_wrap("j", "k"), { desc = "Jump to window (down)" })
map("n", "<C-k>", try_window_jump_with_wrap("k", "j"), { desc = "Jump to window (up)" })
map("n", "<C-l>", try_window_jump_with_wrap("l", "h"), { desc = "Jump to window (left)" })

-- Copy selected text to system clipboard
map("v", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
-- Replace selected text without yanking
map("v", "<leader>p", '"_dP', { desc = "Replace without yanking" })
-- Delete selected text without yanking
map("v", "<leader>d", '"-d"', { desc = "Delete without yanking" })
