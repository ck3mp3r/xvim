return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    opts = {
      sync_with_nvim_tree = true
    },
    dependencies = {
      "plenary.nvim/plenary.nvim",
      {
        "ahmedkhalf/project.nvim",
        config = function()
          require("project_nvim").setup {}
        end,
        event = { "VimEnter" },
      },
      {
        "nvim-telescope/telescope-project.nvim",
        config = function()
          require 'telescope'.load_extension('project')
        end
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        config = function()
          require 'telescope'.load_extension('fzf')
        end
      },
      'nvim-telescope/telescope-ui-select.nvim',
    },
  }
}
