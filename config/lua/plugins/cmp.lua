return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      local cmp = require 'cmp'
      local lspkind = require 'lspkind'
      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 60,
            ellipsis_char = '...',
            show_labelDetails = false,
            before = function(_, vim_item)
              return vim_item
            end
          })
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "treesitter" },
          { name = "path" },
          { name = "buffer" },
          -- {name = 'nvim_lsp_signature_help'},
          -- {name = 'nvim_lsp_document_symbol'},
          -- { name = "cmp_tabnine"; }
          -- { name = "calc"; }
          -- { name = "emoji"; }
          -- { name = "crates"; }
          -- { name = "tmux"; }
        }),
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-p>"] = cmp.mapping.complete(),
          ["<C-n>"] = cmp.mapping.complete(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-e>"] = cmp.mapping.close(),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i', 's' }),
          ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i', 's' })
        }
        ),

        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },

        experimental = {
          ghost_text = false,
          native_menu = false
        },

        window = {
          completion = {
            border = "rounded"
          },
          documentation = {
            border = "rounded"
          }
        }
      })
    end,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "onsails/lspkind-nvim",
      {
        "L3MON4D3/LuaSnip",
        dependencies = {
          "saadparwaiz1/cmp_luasnip"
        },
      }
    },
  },
}
