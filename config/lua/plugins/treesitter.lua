local ts_parsers = vim.g.ts_parsers
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    opts = {
      install_dir = ts_parsers,
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function(_, opts)
      vim.opt.runtimepath:prepend(ts_parsers)
      require("nvim-treesitter").setup(opts)

      -- Enable highlighting for all filetypes with tree-sitter parsers
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          local ft = vim.bo[buf].filetype
          if ft ~= "" then
            pcall(vim.treesitter.start, buf)
          end
        end,
      })

      -- Enable indent expression for tree-sitter
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
