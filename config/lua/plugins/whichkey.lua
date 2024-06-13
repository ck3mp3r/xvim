return {
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    config = function()
      require 'which-key'.setup({})
      require 'which-key'.register({
        e = { ":NvimTreeToggle <CR>", "Toggle Explorer" },
        h = { ":nohlsearch<CR>", "No Highlight" },
        q = { ":qa <CR>", "quit" },
        s = {
          name = "[s]earch",
        },
        g = {
          name = "[g]it",
          C = { ":Telescope git_bcommits<cr>", "Checkout commit (for current file)" },
          R = { ":lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
          b = { ":Telescope git_branches<cr>", "Checkout branch" },
          c = { ":Telescope git_commits<cr>", "Checkout commit" },
          d = { ":Gitsigns diffthis HEAD<cr>", "Git Diff" },
          g = { ":lua require 'xvim-components'.toggle()<cr>", "Lazygit" },
          j = { ":lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
          k = { ":lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
          l = { ":lua require 'gitsigns'.blame_line()<cr>", "Blame" },
          n = { ":Neogit<cr>", "Open Neogit" },
          o = { ":Telescope git_status<cr>", "Open changed file" },
          p = { ":lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
          r = { ":lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
          s = { ":lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
          t = { ":GitBlameToggle<cr>", "Toggle Git Blame" },
          u = { ":lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
        },
        l = {
          name = "[l]sp",
          i = { ":LspInfo<cr>", "Info" },
          d = { ":Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
          w = { ":Telescope diagnostics<cr>", "Diagnostics" },
          s = { ":Telescope lsp_document_symbols<cr>", "Document Symbols" },
          S = { ":Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
          e = { ":Telescope quickfix<cr>", "Telescope Quickfix" },
          j = { ":lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
          k = { ":lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
          q = { ":lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
          a = { ":lua vim.lsp.buf.code_action()<cr>", "Code Action" },
          f = { ":lua vim.lsp.buf.format({timeout_ms=5000})<cr>", "Format" },
          r = { ":lua vim.lsp.buf.rename()<cr>", "Rename" },
          l = { ":lua vim.lsp.codelens.run()<cr>", "CodeLens Action" }
        },
        b = {
          name = "[b]uffer",
          c = { ":Bdelete<CR>", "Close" },
          o = { ":BufferLineCloseOthers <CR>", "Close Others" },
          h = { ":BufferLineCloseLeft <CR>", "Close Left" },
          l = { ":BufferLineCloseRight <CR>", "Close Right" },
          e = { ":BufferLinePickClose <CR>", "Pick To Close" },
        },
        d = { ":DirenvExport <CR>", "Direnv Export" },
        t = {
          name = "Toggle Term",
          f = { ":ToggleTerm direction=float<cr>", "Floating terminal" },
          h = { ":ToggleTerm direction=horizontal<cr>", "Horizontal terminal" },
          v = { ":ToggleTerm direction=vertical<cr>", "Vertical terminal" },
        },
        z = { ":ZenMode <CR>", "Toggle ZenMode" }
      }, { prefix = "<leader>" })
    end
  }
}
