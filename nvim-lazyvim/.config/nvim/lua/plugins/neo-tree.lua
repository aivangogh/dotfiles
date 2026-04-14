-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  "nvim-neo-tree/neo-tree.nvim",
  -- Note: version = "*" and dependencies are already handled by LazyVim,
  -- but keeping them doesn't hurt.
  keys = {
    -- Changed from :Neotree reveal to the lua command for better stability
    { "<leader>e", "<cmd>Neotree reveal<cr>", desc = "NeoTree reveal" },
  },
  opts = {
    filesystem = {
      -- This ensures neo-tree opens when you open a directory
      hijack_netrw_behavior = "open_default",
      use_libuv_file_watcher = true,
      follow_current_file = {
        enabled = true,
        -- Set this to false if you want neo-tree to auto-expand
        -- directories to find the current file
        leave_dirs_open = false,
      },
      window = {
        position = "float",
        mappings = {
          ["<C-n>"] = "close_window",
          ["<space>"] = "open",
        },
      },
    },
    -- If using float, it's often helpful to define the popup layout here
    -- to ensure it doesn't revert to sidebar defaults
    window = {
      position = "float",
      popup = {
        size = { height = "85%", width = "75%" },
        position = "50%",
      },
    },
  },
}
