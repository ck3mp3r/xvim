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

vim.api.nvim_set_keymap('n', '<C-s>', '<cmd>lua vim.cmd("w")<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Function to detect Tiltfile as starlark filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "Tiltfile",
  callback = function()
    vim.bo.filetype = "starlark"
  end,
})
