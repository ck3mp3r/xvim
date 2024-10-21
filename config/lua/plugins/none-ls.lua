return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPost" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.prettier.with({
            filetypes = { "json" }, -- Enable for JSON files
          }),
          null_ls.builtins.formatting.cue_fmt.with({
            command = "cue",
            args = { "fmt" },
            filetypes = { "cue" },
          }),
          null_ls.builtins.diagnostics.cue_fmt.with({
            command = "cue",
            args = { "vet" },
            filetypes = { "cue" },
          }),
        }
      })
    end
  }
}
