return {
	"rmagatti/auto-session",
	lazy = false,
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		{ "<leader>wr", "<cmd>SessionSearch<CR>", desc = "Session search" },
		{ "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session" },
		{ "<leader>wa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
	},
	config = function()
		require("auto-session").setup({
			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			auto_restore_enabled = false,

			session_lens = {
				load_on_setup = true,
				theme_conf = { border = true },
				previewer = false,
				mappings = {
					delete_session = { "i", "<C-D>" },
					alternate_session = { "i", "<C-S>" },
				},
			},

			auto_session_create_enabled = function()
				local cmd = "git rev-parse --is-inside-work-tree"
				return vim.fn.system(cmd) == "true\n"
			end,

			args_allow_files_auto_save = function()
				local supported = 0

				local tabpages = vim.api.nvim_list_tabpages()
				for _, tabpage in ipairs(tabpages) do
					local windows = vim.api.nvim_tabpage_list_wins(tabpage)
					for _, window in ipairs(windows) do
						local buffer = vim.api.nvim_win_get_buf(window)
						local file_name = vim.api.nvim_buf_get_name(buffer)
						if vim.fn.filereadable(file_name) ~= 0 then
							supported = supported + 1
						end
					end
				end

				-- If we have 2 or more windows with supported buffers, save the session
				return supported >= 2
			end,
		})
	end,
}
