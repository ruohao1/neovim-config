vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true

vim.opt.wrap = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true
vim.opt.updatetime = 200
vim.opt.timeoutlen = 400

vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

-- Better splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Undo history
vim.opt.undofile = true

-- Diagnostics UI
vim.diagnostic.config({
	virtual_text = true,
	severity_sort = true,
	float = { border = "single" },
})
