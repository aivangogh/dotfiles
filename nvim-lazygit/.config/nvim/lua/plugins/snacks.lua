return {
  "folke/snacks.nvim",
  keys = {
    -- Disable the original default keymaps to declutter which-key
    { "<leader>,", false },
    { "<leader>fb", false },
    { "<leader><space>", false },

    -- Change the default "Buffers" keymap
    {
      "<leader><space>",
      function()
        require("snacks.picker").buffers()
      end,
      desc = "Buffers",
    },
    -- Add a new keymap to grep open buffers
    {
      "<leader>b/",
      function()
        require("snacks.picker").grep_buffers()
      end,
      desc = "Grep Open Buffers",
    },
  },
  opts = {
    scroll = { enabled = false },
    dashboard = {
      theme = "doom",
      enabled = true,
      preset = {
        header = {
          [[                                                                       
                                                                      
      ████ ██████           █████      ██								btw        
       ███████████             █████                             
		   █████████ ███████████████████ ███   ███████████   
	    █████████  ███    █████████████ █████ ██████████████   
	   █████████ ██████████ █████████ █████ █████ ████ █████   
   ███████████ ███    ███ █████████ █████ █████ ████ █████  
██████  █████████████████████ ████ █████ █████ ████ ██████
						]],
        },
      },
    },
    sections = {
      { section = "header", align = "center" },
    },
  },
}
