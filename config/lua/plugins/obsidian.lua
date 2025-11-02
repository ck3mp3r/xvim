local vault_location = vim.fn.expand(vim.env.OBSIDIAN_VAULT or "~/Documents/obsidian-notes")

return {
  "obsidian-nvim/obsidian.nvim",
  lazy = true,
  cmd = "Obsidian",
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

    -- Daily notes
    daily_notes = {
      folder = "daily",
      template = "daily.md",
    },

    -- Templates
    templates = {
      folder = "templates",
      substitutions = {
        yesterday = function()
          return os.date("%Y-%m-%d", os.time() - 86400)
        end,
      },
      -- Template customizations - key must match template filename WITHOUT .md
      customizations = {
        meeting = {
          notes_subdir = "meetings",
        },
        todo = {
          notes_subdir = "todos",
        },
        project = {
          notes_subdir = "projects",
        },
        note = {
          notes_subdir = "notes",
        },
      },
    },
  },
}
