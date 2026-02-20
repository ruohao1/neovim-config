local aug = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

-- Format-on-save toggles
vim.g.format_on_save = false

local function buf_format_enabled(bufnr)
	local v = vim.b[bufnr].format_on_save
	if v == nil then
		return vim.g.format_on_save
	end
	return v
end

vim.api.nvim_create_user_command("FormatToggle", function()
	vim.g.format_on_save = not vim.g.format_on_save
	vim.notify("format_on_save (global): " .. tostring(vim.g.format_on_save))
end, {})

vim.api.nvim_create_user_command("FormatToggleBuffer", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local cur = vim.b[bufnr].format_on_save
	if cur == nil then
		cur = vim.g.format_on_save
	end
	vim.b[bufnr].format_on_save = not cur
	vim.notify("format_on_save (buffer): " .. tostring(vim.b[bufnr].format_on_save))
end, {})

-- Format on save (uses LSP formatting providers + none-ls)
au("BufWritePre", {
	group = aug("core_format_on_save", { clear = true }),
	callback = function(args)
		if not buf_format_enabled(args.buf) then
			return
		end

		-- Only run if there is at least one formatter attached
		local clients = vim.lsp.get_clients({ bufnr = args.buf })
		local has_formatter = false
		for _, c in ipairs(clients) do
			if c.supports_method("textDocument/formatting") then
				has_formatter = true
				break
			end
		end
		if not has_formatter then
			return
		end

		vim.lsp.buf.format({
			bufnr = args.buf,
			timeout_ms = 2000,
		})
	end,
})

-- LSP keymaps ONLY on attach
au("LspAttach", {
	group = aug("core_lsp_attach", { clear = true }),
	callback = function(args)
		local bufnr = args.buf
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end

		map("n", "gd", vim.lsp.buf.definition, "Go to definition")
		map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
		map("n", "gr", vim.lsp.buf.references, "References")
		map("n", "gi", vim.lsp.buf.implementation, "Implementation")
		map("n", "K", vim.lsp.buf.hover, "Kover")
		map("n", "<leader>lr", vim.lsp.buf.rename, "Rename")
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

		map("n", "<leader>ld", vim.diagnostic.open_float, "Diagnostics: float")
		map("n", "[d", vim.diagnostic.goto_prev, "Diagnostics: prev")
		map("n", "]d", vim.diagnostic.goto_next, "Diagnostics: next")

		map("n", "<leader>lf", function()
			vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
		end, "Format buffer")

		-- Doctor helpers (buffer-local)
		map("n", "<leader>li", "<cmd>LspInfo<CR>", "LspInfo")
		map("n", "<Leader>lr", "<Cmd>LspRestart<CR>", "LspRestart")
		map("n", "<leader>ls", function()
			local clients = vim.lsp.get_clients({ bufnr = bufnr })
			if #clients == 0 then
				vim.notify("No LSP clients attached to this buffer")
				return
			end
			local lines = {}
			for _, c in ipairs(clients) do
				table.insert(lines, ("- %s (id=%d) root=%s"):format(c.name, c.id, c.config.root_dir or "nil"))
			end
			vim.notify(table.concat(lines, "\n"))
		end, "Show attached clients/root")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_treesitter_start", { clear = true }),
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})
