local vault_location = vim.fn.expand("~") .. "/Documents/obsidian-notes"
return {

  "epwalsh/obsidian.nvim",
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
    completion = {
      -- blink_cmp = true,
    },
    workspaces = {
      {
        name = "personal",
        path = vault_location,
      },
      -- {
      --   name = "work",
      --   path = "~/vaults/work",
      -- },
    },
  },
}
