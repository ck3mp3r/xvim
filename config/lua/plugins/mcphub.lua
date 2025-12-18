return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- mcphub must be loaded before codecompanion calls its extension
    lazy = false,
    opts = {
      cmd = vim.g.mcp_cli,
    },
  },
}
