vim.g.lazyvim_check_order = false
require("config.lazy")
vim.opt.runtimepath:remove(vim.fn.expand("~/.config/nvim"))
