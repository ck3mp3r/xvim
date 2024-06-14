return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    opts = {
      sync_with_nvim_tree = true
    },
    config = function(_, opts)
      require('telescope').setup(opts)
      local builtin = require 'telescope.builtin'

      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>s<leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>b/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          -- winblend = 10,
          previewer = false,
        })
      end, { desc = '[B]uffer [/] Fuzzily search' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })
    end,
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
          vim.keymap.set('n', '<leader>sp', ':Telescope projects <cr>', { desc = '[S]earch [P]roject' })
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
