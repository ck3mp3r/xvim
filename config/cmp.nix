{
  plugins.nvim-cmp = {
    enable = true;
    sources = [
      { name = "nvim_lsp"; }
      { name = "nvim_lua"; }
      { name = "luasnip"; }
      { name = "treesitter"; }
      { name = "path"; }
      { name = "buffer"; }
      # { name = "cmp_tabnine"; }
      # { name = "calc"; }
      # { name = "emoji"; }
      # { name = "crates"; }
      # { name = "tmux"; }
    ];

    mapping = {
      "<C-Space>" = "cmp.mapping.complete()";
      "<C-p>" = "cmp.mapping.complete()";
      "<C-n>" = "cmp.mapping.complete()";
      "<C-d>" = "cmp.mapping.scroll_docs(-4)";
      "<C-e>" = "cmp.mapping.close()";
      "<C-f>" = "cmp.mapping.scroll_docs(4)";
      "<CR>" = "cmp.mapping.confirm({ select = true })";
      "<S-Tab>" = {
        action = "cmp.mapping.select_prev_item()";
        modes = [ "i" "s" ];
      };
      "<Tab>" = {
        action = "cmp.mapping.select_next_item()";
        modes = [ "i" "s" ];
      };
    };

    snippet.expand = "luasnip";

    experimental = {
      ghost_text = false;
      native_menu = false;
    };

    window.completion.border = "rounded";
    window.documentation.border = "rounded";
  };

  plugins.lspkind = {
    enable = true;
    mode = "symbol";
    cmp = {
      enable = true;
      menu = {
        buffer = "(Buffer)";
        nvim_lsp = "(LSP)";
        path = "(Path)";
        luasnip = "(Snippet)";
        nvim_lua = "(Lua)";
        calc = "(Calc)";
        emoji = "(Emoji)";
        treesitter = "(Treesitter)";
        crates = "(Crates)";
        tmux = "(Tmux)";
      };
    };
  };

  plugins.cmp-nvim-lsp.enable = true;
  plugins.luasnip.enable = true;
}
