return {
  {
    "NickvanDyke/opencode.nvim",
    event = "VeryLazy",
    keys = {
      -- OpenCode keymaps (using <leader>a prefix for AI)
      {
        "<leader>aa",
        function()
          require("opencode").ask("@this: ", { submit = true })
        end,
        desc = "OpenCode: Ask with context",
        mode = { "n", "x" },
      },
      {
        "<leader>as",
        function()
          require("opencode").select()
        end,
        desc = "OpenCode: Select action",
        mode = { "n", "x" },
      },
      {
        "<leader>ap",
        function()
          require("opencode").prompt("@this")
        end,
        desc = "OpenCode: Prompt with context",
        mode = { "n", "x" },
      },
      {
        "<leader>au",
        function()
          require("opencode").command("session.half.page.up")
        end,
        desc = "OpenCode: Scroll up",
      },
      {
        "<leader>ad",
        function()
          require("opencode").command("session.half.page.down")
        end,
        desc = "OpenCode: Scroll down",
      },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see lua/opencode/config.lua, or "goto definition"
      }

      -- Required for opts.events.reload
      vim.o.autoread = true

      -- Create :OpenCode command
      vim.api.nvim_create_user_command("oc", function()
        require("opencode").toggle()
      end, {
        desc = "Toggle OpenCode",
      })
    end,
  },
}
