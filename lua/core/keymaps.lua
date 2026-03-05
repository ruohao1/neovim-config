local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Clear search highlight
map("n", "<leader>h", "<cmd>nohlsearch<cr>", opts)
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Qa", "qa", {})
vim.api.nvim_create_user_command("QA", "qa", {})

-- Better motion
map("i", "jj", "<Esc>", opts)
map("i", "kk", "<Esc>", opts)
map("i", "jk", "<Esc>", opts)
map("i", "kj", "<Esc>", opts)

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize splits
map("n", "<A-h>", "<cmd>vertical resize -3<cr>", opts)
map("n", "<A-l>", "<cmd>vertical resize +3<cr>", opts)
map("n", "<A-j>", "<cmd>resize -2<cr>", opts)
map("n", "<A-k>", "<cmd>resize +2<cr>", opts)
map("n", "<leader>\\", "<cmd>vsplit<cr>", opts)
map("n", "<leader>|", "<cmd>split<cr>", opts)

-- Replace word
vim.keymap.set("n", "<leader>rw", function()
	local cword = vim.fn.expand("<cword>")
	local old = vim.fn.input("Replace (word): ", cword)
	if old == "" then
		return
	end
	local new = vim.fn.input("With: ")

	-- With \V (very nomagic), only escape delimiter and backslash in the pattern
	local pat = vim.fn.escape(old, [[\/\]])
	-- In replacement, also escape '&' (whole-match expansion)
	local rep = vim.fn.escape(new, [[\/\&]])

	vim.cmd("silent! vimgrep /\\<\\V" .. pat .. "\\>/gj **/*")
	vim.cmd("copen")
	vim.cmd("cdo %s/\\<\\V" .. pat .. "\\>/" .. rep .. "/gc | update")
end, { desc = "Project replace (confirm each) via quickfix" })
