return {
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    config = function(_, _)
      require("codecompanion").setup({
        display = {
          action_palette = {
            width = 95,
            height = 10,
            prompt = "Prompt ", -- Prompt used for interactive LLM calls
            provider = "default", -- Can be "default", "telescope", or "mini_pick". If not specified, the plugin will autodetect installed providers.
            opts = {
              show_default_actions = true, -- Show the default actions in the action palette?
              show_default_prompt_library = true, -- Show the default prompt library in the action palette?
            },
          },
        },
      })
    end,
    dependencies = {

      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
