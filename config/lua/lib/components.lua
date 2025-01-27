local icons = require("lib.icons")

M = {}

M.lsp = function()
  local buf_clients = {}
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.attached_buffers[vim.api.nvim_get_current_buf()] then
      table.insert(buf_clients, client)
    end
  end
  if #buf_clients == 0 then
    return "LSP Inactive"
  end

  local buf_client_names = {}

  for _, client in pairs(buf_clients) do
    if client.name ~= "null-ls" and client.name ~= "copilot" then
      table.insert(buf_client_names, client.name)
    end
  end

  if #buf_client_names == 0 then
    return "LSP Inactive"
  end

  local unique_client_names = table.concat(buf_client_names, ", ")
  local language_servers = string.format("[%s]", unique_client_names)

  return language_servers
end

M.spaces = function()
  local shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
  return icons.ui.Tab .. " " .. shiftwidth
end

return M
