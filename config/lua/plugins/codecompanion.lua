return {
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    config = function()
      -- Configuration constants
      local config = {
        anthropic_version = "2023-06-01",
        anthropic_beta = "claude-code-20250219,oauth-2025-04-20,interleaved-thinking-2025-05-14,fine-grained-tool-streaming-2025-05-14",
        claude_code_system_message = "You are Claude Code, Anthropic's official CLI for Claude.",
        allowed_message_fields = { "content", "role", "reasoning", "tool_calls" },
      }

      -- Validate OAuth token setup
      local function validate_oauth_setup()
        local oauth_token = vim.env.CLAUDE_CODE_OAUTH_TOKEN

        if not oauth_token or oauth_token == "" then
          vim.notify("✗ No Claude OAuth token found - make sure to use the wrapper script", vim.log.levels.ERROR)
          return false
        end

        vim.notify("✓ Claude OAuth token configured", vim.log.levels.INFO)
        return true
      end

      -- Helper function to keep only allowed message fields
      local function keep_allowed_message_fields(message, allowed_fields)
        local cleaned_message = {}
        for key, value in pairs(message) do
          if vim.tbl_contains(allowed_fields, key) then
            cleaned_message[key] = value
          end
        end
        return cleaned_message
      end

      -- Add Claude Code system message at the beginning
      local function add_claude_code_system_message(system)
        table.insert(system, 1, {
          type = "text",
          text = config.claude_code_system_message,
          cache_control = {
            type = "ephemeral",
          },
        })
        return system
      end

      -- Process image content for vision models
      local function process_image_content(message, self)
        if message.opts and message.opts.tag == "image" and message.opts.mimetype then
          if self.opts and self.opts.vision then
            message.content = {
              {
                type = "image",
                source = {
                  type = "base64",
                  media_type = message.opts.mimetype,
                  data = message.content,
                },
              },
            }
          else
            return nil
          end
        end
        return message
      end

      -- Apply caching to messages and system prompts
      local function apply_message_caching(messages, system, self, tokens)
        local breakpoints_used = 0

        -- Cache user messages
        for i = #messages, 1, -1 do
          local msgs = messages[i]
          if msgs.role == self.roles.user and msgs.content and type(msgs.content) == "table" then
            for _, msg in ipairs(msgs.content) do
              if msg.type == "text" and msg.text and msg.text ~= "" then
                if
                  tokens.calculate(msg.text) >= (self.opts.cache_over or 2048)
                  and breakpoints_used < (self.opts.cache_breakpoints or 3)
                then
                  msg.cache_control = { type = "ephemeral" }
                  breakpoints_used = breakpoints_used + 1
                end
              end
            end
          end
        end

        -- Cache system messages
        if system and breakpoints_used < (self.opts.cache_breakpoints or 3) then
          for _, prompt in ipairs(system) do
            if breakpoints_used < (self.opts.cache_breakpoints or 3) then
              prompt.cache_control = { type = "ephemeral" }
              breakpoints_used = breakpoints_used + 1
            end
          end
        end
      end

      -- Consolidate tool results
      local function consolidate_tool_results(messages, self)
        for _, m in ipairs(messages) do
          if m.role == self.roles.user and m.content and m.content ~= "" then
            if type(m.content) == "table" and m.content.type then
              m.content = { m.content }
            end

            if type(m.content) == "table" and vim.islist(m.content) then
              local consolidated = {}
              for _, block in ipairs(m.content) do
                if block.type == "tool_result" then
                  local prev = consolidated[#consolidated]
                  if prev and prev.type == "tool_result" and prev.tool_use_id == block.tool_use_id then
                    prev.content = prev.content .. block.content
                  else
                    table.insert(consolidated, block)
                  end
                else
                  table.insert(consolidated, block)
                end
              end
              m.content = consolidated
            end
          end
        end
      end

      -- Validate setup and get OAuth token
      local is_valid = validate_oauth_setup()

      local adapters = {}
      if is_valid then
        local utils = require("codecompanion.utils.adapters")
        local tokens = require("codecompanion.utils.tokens")

        adapters.anthropic = require("codecompanion.adapters").extend("anthropic", {
          env = {
            bearer_token = "CLAUDE_CODE_OAUTH_TOKEN",
          },
          headers = {
            ["content-type"] = "application/json",
            ["authorization"] = "Bearer ${bearer_token}",
            ["anthropic-version"] = config.anthropic_version,
            ["anthropic-beta"] = config.anthropic_beta,
          },
          handlers = {
            setup = function(self)
              -- Remove x-api-key header if it exists (from base adapter)
              if self.headers and self.headers["x-api-key"] then
                self.headers["x-api-key"] = nil
              end

              if self.opts and self.opts.stream then
                self.parameters.stream = true
              end

              local model = self.schema and self.schema.model and self.schema.model.default
              if model then
                local model_opts = self.schema.model.choices and self.schema.model.choices[model]
                if model_opts and model_opts.opts then
                  self.opts = vim.tbl_deep_extend("force", self.opts or {}, model_opts.opts)
                  if not model_opts.opts.has_vision then
                    self.opts.vision = false
                  end
                end
              end

              return true
            end,

            form_messages = function(self, messages)
              local has_tools = false

              -- Extract and format system messages
              ---@type table|nil
              local system = vim
                .iter(messages)
                :filter(function(msg)
                  return msg.role == "system"
                end)
                :map(function(msg)
                  return {
                    type = "text",
                    text = msg.content,
                    cache_control = nil,
                  }
                end)
                :totable()

              -- Add Claude Code system message
              system = add_claude_code_system_message(system)
              -- Ensure system is nil if empty to satisfy type checker
              if #system == 0 then
                system = nil
              end

              -- Filter out system messages from main message list
              messages = vim
                .iter(messages)
                :filter(function(msg)
                  return msg.role ~= "system"
                end)
                :totable()

              -- Process each message
              messages = vim.tbl_map(function(message)
                -- Handle image content
                message = process_image_content(message, self)
                if message == nil then
                  return nil
                end

                -- Clean message fields
                message = keep_allowed_message_fields(message, config.allowed_message_fields)

                -- Handle user and LLM roles
                if message.role == self.roles.user or message.role == self.roles.llm then
                  if message.role == self.roles.user and message.content == "" then
                    message.content = "<prompt></prompt>"
                  end

                  if type(message.content) == "string" then
                    message.content = {
                      { type = "text", text = message.content },
                    }
                  end
                end

                -- Track tools usage
                if message.tool_calls and vim.tbl_count(message.tool_calls) > 0 then
                  has_tools = true
                end

                -- Convert tool role to user role
                if message.role == "tool" then
                  message.role = self.roles.user
                end

                -- Handle tool calls in LLM messages
                if has_tools and message.role == self.roles.llm and message.tool_calls then
                  -- Ensure content is always a table when handling tool calls
                  local content = message.content
                  if type(content) ~= "table" then
                    content = {}
                    message.content = content
                  end

                  for _, call in ipairs(message.tool_calls) do
                    local success, decoded_args = pcall(vim.json.decode, call["function"].arguments)
                    table.insert(content, {
                      type = "tool_use",
                      id = call.id,
                      name = call["function"].name,
                      input = success and decoded_args or {},
                    })
                  end
                  message.tool_calls = nil
                end

                -- Handle reasoning/thinking content
                if message.reasoning then
                  local content = message.content
                  if type(content) == "table" then
                    table.insert(content, 1, {
                      type = "thinking",
                      thinking = message.reasoning.content,
                      signature = message.reasoning._data and message.reasoning._data.signature,
                    })
                  end
                end

                return message
              end, messages)

              -- Filter out nil values from the mapped table
              messages = vim.tbl_filter(function(msg)
                return msg ~= nil
              end, messages)

              -- Merge consecutive messages
              messages = utils.merge_messages(messages)

              -- Consolidate tool results if tools are being used
              if has_tools then
                consolidate_tool_results(messages, self)
              end

              -- Apply caching to messages
              apply_message_caching(messages, system, self, tokens)

              return { system = system, messages = messages }
            end,
          },
        })
      end

      require("codecompanion").setup({
        adapters = adapters,
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
