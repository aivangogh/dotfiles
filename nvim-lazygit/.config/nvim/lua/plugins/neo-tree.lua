-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  keys = {
    { "<C-b>", ":Neotree reveal<CR>", desc = "NeoTree reveal" },
  },
  opts = {
    filesystem = {
      popup_border_style = "winborder",
      window = {
        mappings = {
          ["<C-n>"] = "close_window",
          ["<Space>"] = "open",
        },
        position = "float",
        popup = {
          size = { height = "85%", width = "75%" },
        },
      },
    },
  },
}
