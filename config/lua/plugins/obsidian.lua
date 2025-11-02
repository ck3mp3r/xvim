local vault_location = vim.fn.expand(vim.env.OBSIDIAN_VAULT or "~/Documents/obsidian-notes")
return {
  "obsidian-nvim/obsidian.nvim",
  lazy = true,
  -- ft = "markdown",
  event = {
    "BufReadPre " .. vault_location .. "/*.md",
    "BufNewFile " .. vault_location .. "/*.md",
  },
  dependencies = {
    -- Required.
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
