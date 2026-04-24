local M = {}

local registry = {
	{ name = "ansiblels" },
	{ name = "bashls" },
	{ name = "docker_language_server" },
	{ name = "eslint" },
	{ name = "golangci_lint_ls" },
	{ name = "gopls" },
	{ name = "html" },
	{ name = "jsonls" },
	{ name = "ltex" },
	{ name = "lua_ls" },
	{ name = "marksman" },
	{ name = "pyright" },
	{ name = "ruff" },
	{ name = "rust_analyzer" },
	{ name = "sqls" },
	{ name = "stylua" },
	{ name = "terraformls" },
	{ name = "ts_ls" },
	{ name = "yamlls" },
}

local function enabled(entry)
	return entry.enabled ~= false
end

local function mason_enabled(entry)
	return entry.mason ~= false
end

M.servers = function()
	local lsp_servers = {}

	for _, entry in ipairs(registry) do
		if enabled(entry) then
			table.insert(lsp_servers, entry.name)
		end
	end

	return lsp_servers
end

M.mason_servers = function()
	local lsp_servers = {}

	for _, entry in ipairs(registry) do
		if enabled(entry) and mason_enabled(entry) then
			table.insert(lsp_servers, entry.name)
		end
	end

	return lsp_servers
end

M.setup = function()
	local lsp_servers = M.servers()
	local mason_servers = M.mason_servers()
	local attach = require("lsp.attach")
	local ok_blink, blink = pcall(require, "blink.cmp")

	if ok_blink then
		vim.lsp.config("*", {
			capabilities = blink.get_lsp_capabilities(),
		})
	end

	local ok, mason_lsp = pcall(require, "mason-lspconfig")
	if ok then
		mason_lsp.setup({
			ensure_installed = mason_servers,
		})
	end

	for _, entry in ipairs(registry) do
		if enabled(entry) then
			local config = require("lsp.servers." .. (entry.module or entry.name))
			local base_on_attach = config.on_attach
			config.on_attach = function(client, bufnr)
				attach.on_attach(client, bufnr)
				if base_on_attach then
					base_on_attach(client, bufnr)
				end
			end
			vim.lsp.config(entry.name, config)
		end
	end

	vim.lsp.enable(lsp_servers)
end

return M
