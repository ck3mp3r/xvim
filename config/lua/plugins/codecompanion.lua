return {
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    config = function()
      require("codecompanion").setup({
        interactions = {
          chat = {
            variables = {}, -- Initialize empty variables table for mcphub extension
          },
        },
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              make_tools = true,
              show_server_tools_in_chat = true,
              make_vars = true,
              make_slash_commands = true,
              show_result_in_chat = true,
            },
          },
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim", -- Added: ensure mcphub loads before codecompanion
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "codecompanion" },
        },
        ft = { "markdown", "codecompanion" },
      },
    },
  },
}
