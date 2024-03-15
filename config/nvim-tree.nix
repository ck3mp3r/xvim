{vimPlugins, ...}:
with vimPlugins; {
  pkg = nvim-tree-lua;
  dependencies = [
    {
      pkg = nvim-web-devicons;
      config = true;
    }
  ];
  cmd = [
    "NvimTreeToggle"
    "NvimTreeOpen"
    "NvimTreeFocus"
    "NvimTreeFindFileToggle"
  ];
  opts = {
    diagnostics.enable = true;
    modified.enable = true;
    # prefer_startup_root = true;
    sync_root_with_cwd = true;
    respect_buf_cwd = true;
    update_focused_file = {
      enable = true;
      update_root = true;
    };
    renderer = {
      icons.git_placement = "signcolumn";
      root_folder_label.__raw = ''
        function(path)
          return vim.fn.fnamemodify(path, ":t")
        end
      '';
    };
    on_attach.__raw = ''
      function(bufnr)
          local api = require "nvim-tree.api"
          local function opts(desc)
            return {
              desc = "nvim-tree: " .. desc,
              buffer = bufnr,
              noremap = true,
              silent = true,
              nowait = true
            }
          end

          -- default mappings
          api.config.mappings.default_on_attach(bufnr)
          local useful_keys = {
            ["l"] = { api.node.open.edit, opts "Open" },
            ["o"] = { api.node.open.edit, opts "Open" },
            ["<CR>"] = { api.node.open.edit, opts "Open" },
            ["v"] = { api.node.open.vertical, opts "Open: Vertical Split" },
            ["h"] = { api.node.navigate.parent_close, opts "Close Directory" },
            ["C"] = { api.tree.change_root_to_node, opts "CD" },
            ['?'] = { api.tree.toggle_help, opts 'Help' },
          }

          for key, value in pairs(useful_keys) do
            vim.keymap.set('n', key, value[1], value[2])
          end
      end
    '';
    view.signcolumn = "yes";
  };
}
