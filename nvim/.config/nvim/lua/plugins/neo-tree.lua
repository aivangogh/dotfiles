return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      popup_border_style = "rounded",
      window = {
        position = "float",
        popup = {
          size = { height = "75%", width = "65%" },
        },
      },
      default_component_configs = {
        indent = {
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
    })

    vim.keymap.set("n", "<C-b>", "<Cmd>Neotree reveal<CR>", {})
  end,
}
