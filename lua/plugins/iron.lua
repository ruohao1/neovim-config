return {
	{
		"Vigemus/iron.nvim",
		config = function()
			local iron = require("iron.core")
			local view = require("iron.view")
			local common = require("iron.fts.common")

			local function python_ipython_cmd()
				local args = { "--no-autoindent" }

				local venv = vim.env.VIRTUAL_ENV
				local conda = vim.env.CONDA_PREFIX
				local prefix = (venv and venv ~= "" and venv) or (conda and conda ~= "" and conda) or nil

				if prefix then
					local p = prefix .. "/bin/ipython"
					if vim.fn.executable(p) == 1 then
						return { p, unpack(args) }
					end
				end

				local fname = vim.api.nvim_buf_get_name(0)
				local start = (fname ~= "" and vim.fn.fnamemodify(fname, ":p:h")) or vim.loop.cwd()
				local root = vim.fs.root(start, { ".venv", "pyproject.toml", "requirements.txt", ".git" })

				if root then
					local p = root .. "/.venv/bin/ipython"
					if vim.fn.executable(p) == 1 then
						return { p, unpack(args) }
					end
				end

				if vim.fn.executable("ipython") == 1 then
					return { "ipython", unpack(args) }
				end

				return { "python", "-m", "IPython", unpack(args) }
			end

			iron.setup({
				config = {
					-- Whether a repl should be discarded or not
					scratch_repl = true,
					-- Your repl definitions come here
					repl_definition = {
						sh = {
							-- Can be a table or a function that
							-- returns a table (see below)
							command = { "zsh" },
						},
						python = {
							command = python_ipython_cmd,
							format = function(lines)
								local filtered = {}
								for _, line in ipairs(lines) do
									-- Matches lines that DON'T start with '#' (ignoring leading whitespace)
									if not line:match("^%s*#") then
										table.insert(filtered, line)
									end
								end
								-- Pass filtered lines to standard bracketed_paste for proper REPL execution
								return common.bracketed_paste(filtered)
							end,
							block_dividers = { "# %%", "#%%" },
							env = { PYTHON_BASIC_REPL = "1" }, --this is needed for python3.13 and up.
						},
					},
					-- set the file type of the newly created repl to ft
					-- bufnr is the buffer id of the REPL and ft is the filetype of the
					-- language being used for the REPL.
					repl_filetype = function(bufnr, ft)
						return ft
						-- or return a string name such as the following
						-- return "iron"
					end,
					-- Send selections to the DAP repl if an nvim-dap session is running.
					dap_integration = true,
					-- How the repl window will be displayed
					-- See below for more information
					repl_open_cmd = view.split.vertical.rightbelow("%40"),
				},
				-- Iron doesn't set keymaps by default anymore.
				-- You can set them here or manually add keymaps to the functions in iron.core
				keymaps = {
					-- mark_motion = "<leader>mc",
					-- mark_visual = "<leader>mc",
					-- remove_mark = "<leader>md",
				},
				-- If the highlight is on, you can change how it looks
				-- For the available options, check nvim_set_hl
				highlight = {
					italic = true,
				},
				ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
			})

			-- Iron
			local map = vim.keymap.set
			map("n", "<leader>rr", function()
				iron.repl_for(vim.bo.filetype)
			end, { desc = "Toggle/Open" })
			map("n", "<leader>rR", "<cmd>IronRestart<CR>", { desc = "Restart" })
			map("n", "<leader>rF", "<cmd>IronFocus<CR>", { desc = "Focus" })
			map("n", "<leader>rH", "<cmd>IronHide<CR>", { desc = "Hide" })

			map("n", "<leader>rl", function()
				iron.send_line()
			end, { desc = "Send line" })
			map("v", "<leader>rv", function()
				iron.visual_send()
			end, { desc = "Send selection" })
			map("n", "<leader>rf", function()
				iron.send_file()
			end, { desc = "Send file" })
			map("n", "<leader>rp", function()
				iron.send_paragraph()
			end, { desc = "Send paragraph" })
			map("n", "<leader>ru", function()
				iron.send_until_cursor()
			end, { desc = "Send until cursor" })
			map("n", "<leader>rb", function()
				iron.send_code_block(false)
			end, { desc = "Send block" })
			map("n", "<leader>rn", function()
				iron.send_code_block(true)
			end, { desc = "Send block + next" })

			map("n", "<leader>rc", function()
				iron.send(nil, string.char(3)) -- Ctrl+C
			end, { desc = "Interrupt" })

			map("n", "<leader>ro", function()
				iron.send(nil, string.char(12)) -- Ctrl+L (clear screen)
			end, { desc = "Clear" })

			map("n", "<leader>rq", function()
				iron.close_repl() -- Ctrl+D
			end, { desc = "Exit" })
		end,
	},
}
