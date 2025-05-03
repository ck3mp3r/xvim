-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.api.nvim_set_keymap(
  "n",
  "<leader>Ca",
  ":CodeCompanionAction<CR>",
  { desc = "Action", noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "<leader>Cc", ":CodeCompanionChat<CR>", { desc = "Chat", noremap = true, silent = true })
