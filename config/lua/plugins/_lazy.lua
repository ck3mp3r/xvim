local function add_to_runtimepath(config_path)
  if config_path and config_path ~= "" then
    vim.o.runtimepath = vim.o.runtimepath .. "," .. config_path
  end
end

local status, config_path = pcall(vim.api.nvim_get_var, "config_path")
if status then
  add_to_runtimepath(config_path)
end

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "Catppuccin",
    },
    import = "lazyvim.plugins"
  },
  { import = "lazyvim.plugins.extras.coding.mini-surround" },
  { import = "lazyvim.plugins.extras.dap.core" },
  { import = "lazyvim.plugins.extras.formatting.black" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
}
