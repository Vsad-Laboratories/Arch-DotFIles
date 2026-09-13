-- =====================================================
-- Keymaps (loaded on VeryLazy event)
-- =====================================================

local map = vim.keymap.set

vim.keymap.set("n", "<leader>r", function()
  vim.cmd("w") -- Auto-save current file
  local file = vim.fn.expand("%")
  local out = vim.fn.expand("%:r")
  local cmd = string.format("g++ -std=c++20 -O2 %s -o %s && ./%s", file, out, out)
  Snacks.terminal(cmd)
end, { desc = "Compile and Run C++" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize window with arrow keys
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Move lines (visual)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Terminal escape
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Quick save
map({ "n", "i", "v" }, "<C-s>", "<cmd>silent write<CR>", { desc = "Save file" })

-- GUI IDE-style shortcuts
-- Ctrl+Backspace: delete word backward (insert mode)
map("i", "<C-BS>", "<C-w>", { desc = "Delete word backward" })
-- Ctrl+Delete: delete word forward (insert + normal)
map("i", "<C-Del>", "<C-o>dw", { desc = "Delete word forward" })
map("n", "<C-Del>", "dw", { desc = "Delete word forward" })
-- Ctrl+Z: undo
map({ "n", "i" }, "<C-z>", "<cmd>undo<CR>", { desc = "Undo" })
-- Ctrl+Shift+Z / Ctrl+Y: redo
map({ "n", "i" }, "<C-S-z>", "<cmd>redo<CR>", { desc = "Redo" })
map({ "n", "i" }, "<C-y>", "<cmd>redo<CR>", { desc = "Redo" })
-- Ctrl+A: select all
map("n", "<C-a>", "ggVG", { desc = "Select all" })
map("i", "<C-a>", "<Esc>ggVG", { desc = "Select all" })
-- Ctrl+C: copy (visual)
map("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })
-- Ctrl+V: paste (insert + normal)
map("i", "<C-v>", "<C-r>+", { desc = "Paste from clipboard" })
map("n", "<C-v>", '"+p', { desc = "Paste from clipboard" })
-- Ctrl+X: cut (visual)
map("v", "<C-x>", '"+d', { desc = "Cut to clipboard" })
