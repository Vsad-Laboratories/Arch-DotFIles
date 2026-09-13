-- =====================================================
-- Editor options (loaded before lazy.nvim startup)
-- Lightweight for 4GB RAM / Ivy Bridge i3
-- =====================================================

local opt = vim.opt

-- Appearance
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes" -- keep diagnostics/git gutter stable (avoids jitter)
opt.cursorline = true
opt.termguicolors = true -- truecolor (kitty supports it)
opt.scrolloff = 8

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Memory / performance (lightweight on 4GB)
opt.hidden = true
opt.updatetime = 250 -- faster LSP/diagnostic updates
opt.timeoutlen = 300 -- faster leader-key responses
opt.swapfile = false -- avoid swap bloat
opt.undofile = true

-- Search & split
opt.inccommand = "split"
opt.splitright = true
opt.splitbelow = true

-- Fold
opt.foldlevel = 99
opt.foldlevelstart = 99
