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
      -- Automatic folder placement per template
      customizations = {
        ["meeting.md"] = {
          notes_subdir = "meetings",
        },
        ["todo.md"] = {
          notes_subdir = "todos",
        },
        ["project.md"] = {
          notes_subdir = "projects",
        },
        ["note.md"] = {
          notes_subdir = "notes",
        },
      },
    },
  },
}
