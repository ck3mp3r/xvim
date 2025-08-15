vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "Tiltfile", "tiltfile.*" },
  callback = function()
    vim.bo.filetype = "python"
  end,
})
