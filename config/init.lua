local function prepend_to_runtimepath(path)
  if path and path ~= "" then
    vim.cmd("set runtimepath^=" .. path)
  end
end

-- Add all folders in a given directory to runtimepath
local function add_folders_to_runtimepath(base_path)
  local uv = vim.loop
  local handle = uv.fs_scandir(base_path)
  if handle then
    while true do
      local name, t = uv.fs_scandir_next(handle)
      if not name then
        break
      end
      local dir_path = base_path .. "/" .. name
      local stat = uv.fs_stat(dir_path)
      local lstat = uv.fs_lstat(dir_path)
      -- Handle normal directories and symlinks to directories
      local is_dir = (stat and stat.type == "directory")
      local is_symlink_dir = (lstat and lstat.type == "link" and stat and stat.type == "directory")
      if is_dir or is_symlink_dir then
        prepend_to_runtimepath(dir_path)
      end
    end
  end
end

local status, path = pcall(vim.api.nvim_get_var, "plugin_path")
if status then
  add_folders_to_runtimepath(path)
end
status, path = pcall(vim.api.nvim_get_var, "config_path")
if status then
  prepend_to_runtimepath(path)
end

require("config.options")
require("plugins.colorscheme")
require("plugins.treesitter")
require("plugins.which-key")
