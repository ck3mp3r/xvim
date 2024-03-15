{pkgs, ...}:
with pkgs.vimPlugins; {
  pkg = nvim-cmp;
  event = ["InsertEnter" "CmdlineEnter"];
  config = ''
    function()
      local cmp = require'cmp'
      local lspkind = require'lspkind'
      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
            show_labelDetails = true,
          })
        },
        sources = cmp.config.sources({
          {name = "nvim_lsp"},
          {name = "nvim_lua"},
          {name = "luasnip"},
          {name = "treesitter"},
          {name = "path"},
          {name = "buffer"},
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
          ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i', 's'}),
          ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i','s'})
          }
        ),

        -- snippet = {
        --   expand = "luasnip"
        -- },

        experimental = {
          ghost_text = false,
          native_menu = false
        },

        window = {
          completion = {
            border = "rounded"
          },
          documentation ={
            border = "rounded"
          }
        }
      })
    end
  '';

  dependencies = [
    cmp-nvim-lsp
    # cmp-nvim-lsp-document-symbol
    # cmp-nvim-lsp-signature-help
    lspkind-nvim
    # luasnip
  ];
}
