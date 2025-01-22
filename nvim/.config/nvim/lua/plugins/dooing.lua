return {
  "atiladefreitas/dooing",
  config = function()
    require("dooing").setup({
      window = {
        width = 60,     -- Width of the floating window
        height = 40,    -- Height of the floating window
        border = "rounded", -- Border style
      },
      keymaps = {
        toggle_window = "<leader>id",
        new_todo = "a",
      },
    })
  end,
}
