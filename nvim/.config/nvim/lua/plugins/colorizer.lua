return {
	"norcalli/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup({
			user_default_options = { names = false },
			filetypes = {
				"*",
				"!lazy",
			},
		})
	end,
}
