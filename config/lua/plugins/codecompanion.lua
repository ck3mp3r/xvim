return {
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    config = function()
      -- Configuration constants
      local config = {
        anthropic_version = "2023-06-01",
        anthropic_beta = "claude-code-20250219,oauth-2025-04-20,interleaved-thinking-2025-05-14,prompt-caching-2024-07-31,token-efficient-tools-2025-02-19",
        claude_code_system_message = "You are Claude Code, Anthropic's official CLI for Claude.",
        allowed_message_fields = { "content", "role", "reasoning", "tools" },
      }

      -- Validate OAuth token setup (only warn in interactive sessions)
      local oauth_token = vim.env.CLAUDE_CODE_OAUTH_TOKEN
      if not oauth_token or oauth_token == "" then
        if vim.fn.has("gui_running") == 1 or vim.env.TERM then
          vim.notify("No Claude OAuth token found - ensure CLAUDE_CODE_OAUTH_TOKEN is set", vim.log.levels.WARN)
        end
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
          cache_control = { type = "ephemeral" },
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

      local utils = require("codecompanion.utils.adapters")
      local tokens = require("codecompanion.utils.tokens")

      require("codecompanion").setup({
        adapters = {
          http = {
            anthropic = function()
              return require("codecompanion.adapters").extend("anthropic", {
                env = {
                  api_key = function()
                    return vim.env.CLAUDE_CODE_OAUTH_TOKEN
                  end,
                },
                schema = {
                  extended_thinking = {
                    default = false,
                  },
                },
                headers = {
                  ["content-type"] = "application/json",
                  ["authorization"] = "Bearer ${api_key}",
                  ["anthropic-version"] = config.anthropic_version,
                  ["anthropic-beta"] = config.anthropic_beta,
                },
                handlers = {
                  setup = function(self)
                    -- Remove x-api-key header (we use Bearer token instead)
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
                    messages = vim.tbl_map(function(m)
                      m = process_image_content(m, self)
                      if m == nil then
                        return nil
                      end

                      m = keep_allowed_message_fields(m, config.allowed_message_fields)

                      -- Ensure content is properly formatted
                      if m.role == self.roles.user or m.role == self.roles.llm then
                        if m.role == self.roles.user and (m.content == "" or m.content == nil) then
                          m.content = "<prompt></prompt>"
                        end

                        if type(m.content) == "string" then
                          m.content = {
                            { type = "text", text = m.content },
                          }
                        end
                      end

                      -- Track tools usage (new format uses m.tools.calls)
                      if m.tools and m.tools.calls and vim.tbl_count(m.tools.calls) > 0 then
                        has_tools = true
                      end

                      -- Handle tool role - convert tool results to Anthropic format
                      if m.role == "tool" then
                        m.role = self.roles.user
                        if m.tools and m.tools.type == "tool_result" then
                          if type(m.content) == "table" and m.content.type == "tool_result" then
                            m.content = { m.content }
                          else
                            m.content = {
                              {
                                type = "tool_result",
                                tool_use_id = m.tools.call_id,
                                content = m.content,
                                is_error = m.tools.is_error or false,
                              },
                            }
                          end
                          m.tools = nil
                        end
                      end

                      -- Handle tool calls in LLM messages (new format)
                      if has_tools and m.role == self.roles.llm and m.tools and m.tools.calls then
                        m.content = m.content or {}
                        for _, call in ipairs(m.tools.calls) do
                          local args = call["function"].arguments
                          table.insert(m.content, {
                            type = "tool_use",
                            id = call.id,
                            name = call["function"].name,
                            input = args ~= "" and vim.json.decode(args) or vim.empty_dict(),
                          })
                        end
                        m.tools = nil
                      end

                      -- Handle reasoning/thinking content
                      if m.reasoning and type(m.content) == "table" then
                        table.insert(m.content, 1, {
                          type = "thinking",
                          thinking = m.reasoning.content,
                          signature = m.reasoning._data and m.reasoning._data.signature,
                        })
                      end

                      return m
                    end, messages)

                    messages = vim.tbl_filter(function(msg)
                      return msg ~= nil
                    end, messages)

                    messages = utils.merge_messages(messages)

                    if has_tools then
                      consolidate_tool_results(messages, self)
                    end

                    apply_message_caching(messages, system, self, tokens)

                    return { system = system, messages = messages }
                  end,
                },
              })
            end,
          },
        },
        interactions = {
          chat = {
            adapter = "anthropic",
          },
        },
        display = {
          action_palette = {
            width = 95,
            height = 10,
            prompt = "Prompt ",
            provider = "default",
            opts = {
              show_default_actions = true,
              show_default_prompt_library = true,
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
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "codecompanion" },
        },
        ft = { "markdown", "codecompanion" },
      },
    },
  },
}
