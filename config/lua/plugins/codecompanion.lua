---@class CodeCompanion.ACPAdapter.NuAgent: CodeCompanion.ACPAdapter
local nu_agent = {
  name = "nu_agent",
  formatted_name = "nu-agent",
  type = "acp",
  roles = {
    llm = "assistant",
    user = "user",
  },
  opts = {
    vision = false,
  },
  commands = {
    default = {
      "agent",
      "acp",
    },
  },
  defaults = {
    mcpServers = {},
    timeout = 20000, -- 20 seconds
  },
  parameters = {
    protocolVersion = 1,
    clientCapabilities = {
      fs = { readTextFile = true, writeTextFile = true },
    },
    clientInfo = {
      name = "CodeCompanion.nvim",
      version = "1.0.0",
    },
  },
  handlers = {
    ---@param self CodeCompanion.ACPAdapter
    ---@return boolean
    setup = function(self)
      return true
    end,

    ---@param self CodeCompanion.ACPAdapter
    ---@return boolean
    auth = function(self)
      return true
    end,

    ---@param self CodeCompanion.ACPAdapter
    ---@param messages table
    ---@param capabilities table
    ---@return table
    form_messages = function(self, messages, capabilities)
      local helpers = require("codecompanion.adapters.acp.helpers")
      return helpers.form_messages(self, messages, capabilities)
    end,

    ---@param self CodeCompanion.ACPAdapter
    ---@param code number
    ---@return nil
    on_exit = function(self, code) end,
  },
}

return {
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    keys = {
      {
        "<leader>Cc",
        "<cmd>CodeCompanionChat<cr>",
        desc = "CodeCompanion: Chat",
        mode = { "n", "x" },
      },
      {
        "<leader>Ca",
        "<cmd>CodeCompanionActions<cr>",
        desc = "CodeCompanion: Actions",
        mode = { "n", "x" },
      },
      {
        "<leader>Ci",
        "<cmd>CodeCompanion<cr>",
        desc = "CodeCompanion: Inline",
        mode = { "n", "x" },
      },
      {
        "<leader>Ct",
        "<cmd>CodeCompanionChat Toggle<cr>",
        desc = "CodeCompanion: Toggle chat",
      },
      {
        "<leader>Cr",
        "<cmd>CodeCompanionCodeReview<cr>",
        desc = "CodeCompanion: Code review",
      },
    },
    opts = {
      adapters = {
        acp = {
          opencode = "opencode",
          nu_agent = nu_agent,
        },
      },
      interactions = {
        chat = {
          adapter = "opencode",
        },
      },
      display = {
        chat = {
          render_headers = false,
        },
        action_palette = {
          width = 80,
          height = 20,
        },
      },
    },
  },
}
