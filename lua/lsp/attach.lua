local M = {}

function M.on_attach(client, _buf)
	if client.name == "pyright" then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end
end

return M
