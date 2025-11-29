return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local lualine = require("lualine")

    local colors = {
      color2 = "#0f1419",
      color3 = "#ffee99",
      color4 = "#e6e1cf",
      color5 = "#14191f",
      color13 = "#b8cc52",
      color10 = "#36a3d9",
      color8 = "#f07178",
      color9 = "#3e4b59",
      color6 = "#0d1017",
      color7 = "#131721",
      color11 = "#0b0e14",
    }
    -- auto change color according to neovims mode and use ayu colors
    local mode_color = {
      n = colors.color10,
      i = colors.color13,
      v = colors.color8,
      [""] = colors.color8,
      V = colors.color8,
      c = colors.color3,
      no = colors.color13,
      s = colors.color3,
      S = colors.color3,
      [""] = colors.color3,
      ic = colors.color3,
      R = colors.color3,
      Rv = colors.color3,
      cv = colors.color3,
      ce = colors.color3,
      r = colors.color3,
      rm = colors.color3,
      ["r?"] = colors.color3,
      ["!"] = colors.color3,
      t = colors.color3,
    }

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
      end,
    }

    -- Config
    local config = {
      options = {
        theme = {
          -- We are going to use lualine_c an lualine_x as left and
          -- right section. Both are highlighted by c theme .  So we
          -- are just setting default looks o statusline
          normal = { c = { fg = colors.color4, bg = colors.color6 } },
          inactive = { c = { fg = colors.color4, bg = colors.color6 } },
        },
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
      },
      sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
      },
    }
    -- Inserts a component in lualine_c at left section
    local function ins_left(component)
      table.insert(config.sections.lualine_c, component)
    end

    -- Inserts a component in lualine_x at right section
    local function ins_right(component)
      table.insert(config.sections.lualine_x, component)
    end

    ins_left({
      "mode",
      icon = { "" },
      separator = { left = "", right = "" },
      color = function()
        return { fg = colors.color2, bg = mode_color[vim.fn.mode()], gui = "bold" }
      end,
    })
    ins_left({
      function()
        return "▊"
      end,
      color = { fg = colors.color9, bg = colors.color9 }, -- Sets highlighting of component
      separator = { left = "", right = "" },
      padding = { left = 0, right = 0 }, -- We don't need space before this
    })

    ins_left({
      "filetype",
      icon_only = true,
      padding = { left = 1, right = 0 },
      color = { bg = colors.color5 },
    })

    ins_left({
      "filename",
      padding = { left = 0, right = 1 },
      separator = { right = "" },
      color = { bg = colors.color5 },
      symbols = {
        modified = "", -- Text to show when the file is modified.
        readonly = "", -- Text to show when the file is non-modifiable or readonly.
        unnamed = "Empty", -- Text to show for unnamed buffers.
        newfile = "New", -- Text to show for newly created file before first write
      },
    })

    -- Right side
    ins_right({
      "diff",
      -- Is it me or the symbol for modified us really weird
      symbols = { added = " ", modified = " ", removed = " " },
      diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.orange },
        removed = { fg = colors.red },
      },
      cond = conditions.hide_in_width,
    })

    ins_right({ "branch", icon = " ", color = { fg = colors.color9 } })

    ins_right({
      "diagnostics",
      symbols = { error = " ", warn = " ", info = " " },
      diagnostics_color = {
        error = { fg = colors.color8 },
        warn = { fg = colors.color3 },
        info = { fg = colors.color10 },
      },
    })

    ins_right({
      -- Lsp server name
      function()
        local msg = "No Active Lsp"
        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
          return msg
        end
        for _, client in ipairs(clients) do
          local filetypes = client.config.filetypes
          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
          end
        end
        return msg
      end,
      icon = "  LSP ~",
      color = { fg = colors.color9, gui = "bold" },
    })

    lualine.setup(config)
  end,
}
