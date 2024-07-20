return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require 'dapui'.setup()
      require 'nvim-dap-virtual-text'.setup()
    end
  }
}
