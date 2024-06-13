local asButton = function(shortcut, desc, command)
  return {
    type = "button",
    val = desc,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(shortcut, true, false, true)
      vim.api.nvim_feedkeys(key, "t", false)
    end,
    opts = {
      position = "center",
      shortcut = shortcut,
      cursor = 3,
      width = 50,
      align_shortcut = "right",
      hl_shortcut = "Keyword",
      keymap = {
        "n",
        shortcut,
        command,
        {
          noremap = true,
          silent = true,
          nowait = true,
        }
      }
    }
  }
end

return {
  {
    "goolord/alpha-nvim",
    lazy = false,
    opts = {
      layout = {
        {
          type = "padding",
          val = 2,
        },
        {
          type = "text",
          val = {
            "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
            "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
            "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
            "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
            "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
            "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
          },
          opts = {
            position = "center",
            hl = "Type",
          },
        },
        {
          type = "padding",
          val = 2,
        },
        {
          type = "group",
          val = {
            asButton(
              "f",
              "󰈞  Find file",
              ":Telescope find_files<CR>"
            ),
            asButton(
              "n",
              "  New file",
              ":ene<CR>"
            ),
            asButton(
              "p",
              "  Projects",
              ":Telescope projects<CR>"
            ),
            asButton(
              "r",
              "  Recent file",
              ":Telescope oldfiles<CR>"
            ),
            asButton(
              "t",
              "󰊄  Find text",
              ":Telescope live_grep<CR>"
            ),
            asButton(
              "q",
              "󰅖  Quit Neovim",
              ":qa<CR>"
            ),
          },
        },
        {
          type = "padding",
          val = 2,
        },
        {
          type = "text",
          val = "Is it Friday yet?!",
          opts = {
            position = "center",
            hl = "Keyword",
          },
        }
      },
    },
  }
}
