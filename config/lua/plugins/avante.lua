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
          model = "gpt-4",
          timeout = 30000,
        },
        ollama = {
          model = "deepseek-coder-v2:16b",
          endpoint = "http://localhost:11434",
          timeout = 30000,
        },
        claude = {
          endpoint = "https://api.anthropic.com",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
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
