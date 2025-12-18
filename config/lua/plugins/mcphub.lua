return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "olimorris/codecompanion.nvim",
    },
    cmd = { "MCPHub" },
    opts = {
      cmd = vim.g.mcp_cli,
      extensions = {
        codecompanion = {
          show_result_in_chat = true,
          make_vars = true,
          make_slash_commands = true,
        },
      },
    },
  },
}
