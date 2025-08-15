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
    import = "lazyvim.plugins",
  },
  { import = "lazyvim.plugins.extras.coding.blink" },
  { import = "lazyvim.plugins.extras.coding.mini-comment" },
  { import = "lazyvim.plugins.extras.coding.mini-surround" },
  { import = "lazyvim.plugins.extras.editor.mini-move" },
  { import = "lazyvim.plugins.extras.formatting.black" },
  { import = "lazyvim.plugins.extras.lang.docker" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.helm" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.nushell" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "lazyvim.plugins.extras.lang.terraform" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
  { import = "lazyvim.plugins.extras.util.rest" },
}
