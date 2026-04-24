return {
	{
		"olimorris/codecompanion.nvim",
		version = "^18.0.0",
		opts = {
			adapters = {
				acp = {
					codex = function()
						return require("codecompanion.adapters").extend("codex", {
							defaults = {
								auth_method = "openai-api-key", -- "openai-api-key"|"codex-api-key"|"chatgpt"
							},
							env = {
								OPENAI_API_KEY = "OPENAI_API_KEY",
							},
						})
					end,
				},
			},
			interactions = {
				chat = {
					keymaps = {
						clear = false,
					},
				},
			},
		},
		config = function(_, opts)
			require("codecompanion").setup(opts)
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
