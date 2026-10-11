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
      -- nu_agent is the verified default; opencode remains selectable
      -- (:AvanteSwitchProvider opencode) when installed.
      provider = "nu_agent",
      -- avante 0.2.3 defaults to auto_approve_tool_permissions = true (silently
      -- answers every ACP session/request_permission, no UI). Disable it so
      -- nu-agent's permission flow (per its permissions DSL, e.g. edit = "ask")
      -- is surfaced.
      --
      -- The default inline_buttons flow is broken against nu-agent: buttons
      -- carry nu-agent's hyphenated optionIds ("allow-once") while the plugin
      -- only recognizes "allow"/"allow_once"/"allow_always", so every click
      -- answers reject_once. The popup dialog answers by option KIND
      -- (allow_once -> allow-once, allow_always -> allow-always,
      -- reject_once -> reject-once), which is correct.
      behaviour = {
        auto_approve_tool_permissions = false,
        confirmation_ui_style = "popup",
      },
      acp_providers = {
        nu_agent = {
          command = "agent",
          args = { "acp" },
          -- avante REPLACES the child environment with PATH + this table
          -- (uv.spawn env), unlike codecompanion which inherits nvim's full
          -- env. nu-agent resolves its config/session-store paths from these.
          env = {
            HOME = os.getenv("HOME"),
            TMPDIR = os.getenv("TMPDIR"),
            XDG_CONFIG_HOME = os.getenv("XDG_CONFIG_HOME"),
            XDG_DATA_HOME = os.getenv("XDG_DATA_HOME"),
            LANG = os.getenv("LANG"),
          },
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
