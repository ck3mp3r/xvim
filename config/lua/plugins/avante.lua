return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    opts = {
      provider = 'copilot',
      use_absolute_path = true,
      vendors = {
        ollama = {
          ['local'] = true,
          endpoint = '127.0.0.1:11434/v1',
          model = 'llama3.2:3b',
          parse_curl_args = function(opts, code_opts)
            return {
              url = opts.endpoint .. '/chat/completions',
              headers = {
                ['Accept'] = 'application/json',
                ['Content-Type'] = 'application/json',
                ['x-api-key'] = 'ollama',
              },
              body = {
                model = opts.model,
                messages = require('avante.providers').copilot.parse_message(code_opts),
                max_tokens = 2048,
                stream = true,
              },
            }
          end,
          parse_response_data = function(data_stream, event_state, opts)
            require('avante.providers').openai.parse_response(data_stream, event_state, opts)
          end,
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "zbirenbaum/copilot.lua",
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    }
  }
}
