return {
  {
    "direnv/direnv.vim",
    event = { "VeryLazy" },
    init = function()
      vim.keymap.set('n', '<leader>wx', ':DirenvExport <CR>', { silent = true, desc = '[W]orkspace Direnv E[x]port' })
    end
  }
}
