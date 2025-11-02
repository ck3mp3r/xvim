local vault_location = vim.fn.expand(vim.env.OBSIDIAN_VAULT or "~/Documents/obsidian-notes")

-- Shared note_id_func for all templates
local function note_id(title)
  local suffix = ""
  if title ~= nil then
    suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
  else
    for _ = 1, 4 do
      suffix = suffix .. string.char(math.random(65, 90))
    end
  end
  return tostring(os.time()) .. "-" .. suffix
end

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
  keys = {
    -- Quick creation shortcuts (templates auto-route to correct folders)
    { "<leader>om", "<cmd>Obsidian new_from_template meeting<cr>", desc = "New meeting" },
    { "<leader>on", "<cmd>Obsidian new_from_template note<cr>", desc = "New note" },
    { "<leader>op", "<cmd>Obsidian new_from_template project<cr>", desc = "New project" },
    { "<leader>ot", "<cmd>Obsidian new_from_template todo<cr>", desc = "New todo" },
    { "<leader>od", "<cmd>Obsidian today<cr>", desc = "Daily note" },

    -- Navigation
    { "<leader>of", "<cmd>Obsidian quick_switch<cr>", desc = "Find note" },
    { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search content" },
    { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
    { "<leader>ol", "<cmd>Obsidian links<cr>", desc = "Links" },
    { "<leader>oT", "<cmd>Obsidian tags<cr>", desc = "Find by tag" },

    -- Other
    { "<leader>oi", "<cmd>Obsidian template<cr>", desc = "Insert template" },
    { "<leader>or", "<cmd>Obsidian rename<cr>", desc = "Rename note" },
    { "<leader>oo", "<cmd>Obsidian open<cr>", desc = "Open in Obsidian app" },
    { "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Toggle checkbox" },

    -- Visual mode
    { "<leader>ox", "<cmd>Obsidian extract_note<cr>", desc = "Extract to new note", mode = "v" },
    { "<leader>oL", "<cmd>Obsidian link<cr>", desc = "Link selection", mode = "v" },
  },
  opts = {
    workspaces = {
      {
        name = "default",
        path = vault_location,
      },
    },

    note_id_func = note_id,

    daily_notes = {
      folder = "daily",
      template = "daily.md",
    },

    templates = {
      folder = "templates",
      customizations = {
        meeting = {
          notes_subdir = "meetings",
          note_id_func = note_id,
        },
        todo = {
          notes_subdir = "todos",
          note_id_func = note_id,
        },
        project = {
          notes_subdir = "projects",
          note_id_func = note_id,
        },
        note = {
          notes_subdir = "notes",
          note_id_func = note_id,
        },
      },
    },
  },
}
