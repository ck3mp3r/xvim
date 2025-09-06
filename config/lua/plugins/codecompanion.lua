-- Function to get OAuth token from macOS keychain
local function get_claude_oauth_token()
  local handle = io.popen('security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null')
  if not handle then
    vim.notify("Failed to execute keychain query command", vim.log.levels.ERROR)
    return nil
  end

  local result = handle:read("*a")
  handle:close()

  if result and result:match("%S") then
    local payload = result:gsub("%s+$", "") -- trim whitespace

    -- Parse JSON payload and extract the access token
    local ok, parsed = pcall(vim.json.decode, payload)
    if not ok then
      vim.notify("Failed to parse Claude credentials JSON: " .. tostring(parsed), vim.log.levels.ERROR)
      return nil
    end

    if parsed.claudeAiOauth and parsed.claudeAiOauth.accessToken then
      return parsed.claudeAiOauth.accessToken
    else
      vim.notify("Invalid Claude credentials format - missing claudeAiOauth.accessToken", vim.log.levels.ERROR)
      return nil
    end
  end

  vim.notify("Claude Code-credentials not found in keychain. ACP adapter disabled.", vim.log.levels.WARN)
  return nil
end

return {
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    config = function(_, _)
      local oauth_token = get_claude_oauth_token()

      if oauth_token then
        vim.env.CLAUDE_CODE_OAUTH_TOKEN = oauth_token
      end

      require("codecompanion").setup({
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              show_result_in_chat = true, -- Show mcp tool results in chat
              make_vars = true, -- Convert resources to #variables
              make_slash_commands = true, -- Add prompts as /slash commands
            },
          },
        },
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
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "codecompanion" },
        },
        ft = { "markdown", "codecompanion" },
      },
    },
  },
}
