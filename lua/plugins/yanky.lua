return {
	{
		"gbprod/yanky.nvim",
		opts = {
			ring = {
				history_length = 100,
				storage = "shada",
				storage_path = vim.fn.stdpath("data") .. "/databases/yanky.db", -- Only for sqlite storage
				sync_with_numbered_registers = true,
				cancel_event = "update",
				ignore_registers = { "_" },
				update_register_on_cycle = false,
				permanent_wrapper = nil,
			},
			picker = {
				select = {
					action = nil, -- nil to use default put action
				},
				telescope = {
					use_default_mappings = false,
					mappings = function()
						local mapping = require("yanky.telescope.mapping")
						local utils = require("yanky.utils")
						return {
							default = mapping.put("p"),
							i = {
								["<c-p>"] = mapping.put("p"),
								["<c-P>"] = mapping.put("P"),
								["<c-d>"] = mapping.delete(),
								["<c-r>"] = mapping.set_register(utils.get_default_register()),
							},
							n = {
								p = mapping.put("p"),
								P = mapping.put("P"),
								d = mapping.delete(),
								r = mapping.set_register(utils.get_default_register()),
							},
						}
					end, -- nil to use default mappings or no mappings (see `use_default_mappings`)
				},
			},
			system_clipboard = {
				sync_with_ring = true,
				clipboard_register = nil,
			},
			highlight = {
				on_put = true,
				on_yank = true,
				timer = 500,
			},
			preserve_cursor_position = {
				enabled = true,
			},
			textobj = {
				enabled = false,
			},
		},
		config = function(_, opts)
			require("yanky").setup(opts)
			require("telescope").load_extension("yank_history")

			vim.keymap.set({ "n", "x" }, "<leader>pp", function()
				local ok_telescope, telescope = pcall(require, "telescope")
				if not ok_telescope then
					vim.notify("Telescope is not available", vim.log.levels.ERROR)
					return
				end

				pcall(telescope.load_extension, "yank_history")
				if not telescope.extensions.yank_history then
					vim.notify("Telescope yank_history extension is not available", vim.log.levels.ERROR)
					return
				end

				telescope.extensions.yank_history.yank_history()
			end, { desc = "Open Yank History" })
		end,
		keys = {
			{ "<leader>pp", mode = { "n", "x" } },
		},
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
	},
}
