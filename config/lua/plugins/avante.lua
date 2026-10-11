return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "stevearc/dressing.nvim",
      "HakonHarnes/img-clip.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    opts = {
      provider = "opencode",
      acp_providers = {
        nu_agent = {
          command = "target/release/agent",
          args = { "acp" },
        },
      },
      -- <leader>a* is taken by opencode.nvim; avante uses <leader>A*
      mappings = {
        ask = "<leader>Aa",
        new_ask = "<leader>An",
        zen_mode = "<leader>Az",
        edit = "<leader>Ae",
        refresh = "<leader>Ar",
        focus = "<leader>Af",
        stop = "<leader>AS",
        toggle = {
          default = "<leader>At",
          debug = "<leader>AD",
          selection = "<leader>AC",
          suggestion = "<leader>As",
          repomap = "<leader>AR",
        },
        files = {
          add_current = "<leader>Ac",
          add_all_buffers = "<leader>AB",
        },
        select_model = "<leader>A?",
        select_history = "<leader>Ah",
        select_acp_model = "<leader>AM",
        select_acp_mode = "<leader>Am",
      },
    },
  },
}
