return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"jsdoc",
				"jsonc",
				"lua", "luadoc", "luap",
				"markdown",
				"markdown_inline",
				"printf",
				"python",
				"query",
				"regex",
				"javascript", "tsx", "typescript",
				"json", "toml", "yaml",
				"go", "gomod", "gowork", "gosum",
			},

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},

			indent = { enable = true },
			textobjects = {
				select = { enable = true, lookahead = true },
				move = { enable = true },
				swap = { enable = true },
			},
		},
	},
}
