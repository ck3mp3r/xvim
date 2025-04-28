local winbar_lualine = {
  {
    "filetype",
    colored = true,
    icon_only = true,
  },
  "filename",
  "navic",
}

local sections = {
  lualine_a = {
    function()
      return require("lib.icons").ui.Target .. " "
    end,
  },
  lualine_b = {
    {
      "branch",
      icon = "",
    },
  },
  lualine_c = { "" },
  lualine_x = {
    { require("lib.components").lsp },
    { require("lib.components").spaces },
    "filetype",
  },
  -- lualine_y = {},
  -- lualine_z = {},
}

--
return {
  {
    "nvim-lualine/lualine.nvim",
    event = { "VimEnter" },
    dependencies = {
      {
        "SmiteshP/nvim-navic",
        opts = {
          lsp = {
            auto_attach = true,
          },
        },
      },
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        globalstatus = true,
        section_separators = {
          left = "",
          right = "",
        },
        component_separators = {
          left = "",
          right = "",
        },
        theme = "catppuccin",
        disabled_filetypes = {
          statusline = { "alpha" },
          winbar = { "NvimTree", "alpha" },
        },
      },

      sections = sections,
      inactive_sections = sections,

      inactive_winbar = { lualine_c = winbar_lualine },

      winbar = { lualine_c = winbar_lualine },
    },
  },
}
