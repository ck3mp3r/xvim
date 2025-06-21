local mcp_cli = vim.g.mcp_cli

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    opts = {
      provider = "copilot",
      auto_suggestions_provider = "copilot",
      providers = {
        copilot = {
          model = "claude-sonnet-4",
          timeout = 30000,
        },
        ollama = {
          model = "qwen3:8b",
          endpoint = "http://localhost:11434",
          timeout = 30000,
        },
        abacus = {
          __inherited_from = "openai",
          endpoint = "https://api.abacus.ai/chat/completions",
          model = "claude-sonnet-4",
          api_key_name = "ABACUS_API_KEY",
          timeout = 30000,
          extra_request_body = {
            temperature = 0.2,
            max_tokens = 4096,
          },
        },
      },
    },
    dependencies = {
      "ibhagwan/fzf-lua",
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      {
        "zbirenbaum/copilot.lua",
        opts = {},
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("mcphub").setup({
        cmd = mcp_cli,
      })
    end,
  },
}
