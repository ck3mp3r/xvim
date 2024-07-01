vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.relativenumber = true

vim.opt.mouse = 'a'

vim.opt.clipboard = "unnamedplus"
vim.opt.colorcolumn = "120"
vim.opt.conceallevel = 1
vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.undofile = true

local lazy_path = vim.g.lazy_path
require("lazy").setup({
  defaults = {
    lazy = true,
  },
  dev = {
    -- reuse files from pkgs.vimPlugins.*
    path = lazy_path,
    patterns = { "." },
    -- fallback to download
    fallback = false,
  },
  install = {
    missing = false
  },
  spec = {
    require "plugins.alpha",
    require "plugins.buffer",
    require "plugins.cmp",
    require "plugins.code.dap",
    require "plugins.code.lsp",
    require "plugins.code.treesitter",
    require "plugins.colorscheme",
    require "plugins.comment",
    require "plugins.direnv",
    require "plugins.git",
    require "plugins.lualine",
    require "plugins.misc",
    require "plugins.noice",
    require "plugins.none-ls",
    require "plugins.nvim-tree",
    require "plugins.telescope",
    require "plugins.toggle-term",
    require "plugins.whichkey",
    require "plugins.zenmode",
  },
})

vim.api.nvim_set_keymap('n', '<C-s>', '<cmd>lua vim.cmd("w")<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
