-- File change detection with confirmation popup
vim.opt.autoread = true

-- Check for external changes on focus/cursor events
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = vim.api.nvim_create_augroup("checktime", { clear = true }),
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Handle external file changes with confirmation
vim.api.nvim_create_autocmd("FileChangedShell", {
  group = vim.api.nvim_create_augroup("file_changed_shell_confirm", { clear = true }),
  callback = function()
    vim.schedule(function()
      local choice = vim.fn.confirm(
        string.format('"%s" changed outside Neovim. Reload?', vim.fn.expand("%:t")),
        "&Yes\n&No\n&Diff",
        1
      )
      if choice == 1 then
        vim.cmd("edit!")
        vim.notify("File reloaded", vim.log.levels.INFO)
      elseif choice == 3 then
        vim.cmd("DiffOrig")
      end
    end)
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "Tiltfile", "tiltfile.*" },
  callback = function()
    vim.bo.filetype = "python"
  end,
})
