local vault_location = vim.fn.expand(vim.env.OBSIDIAN_VAULT or "~/Documents/obsidian-notes")
return {
  "obsidian-nvim/obsidian.nvim",
  lazy = true,
  cmd = "Obsidian", -- Load plugin when any :Obsidian command is used
  event = {
    "BufReadPre " .. vault_location .. "/*.md",
    "BufNewFile " .. vault_location .. "/*.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "default",
        path = vault_location,
      },
    },
  },
}
