{vimPlugins, ...}:
with vimPlugins; {
  pkg = vimPlugins.catppuccin-nvim;
  lazy = false;
  priority = 1000;
  config = ''
    function()
      require('catppuccin').setup({
        transparent_background = true
      })
      local colorscheme = 'catppuccin'
      local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
      if not status_ok then
        vim.notify("Colorscheme " .. colorscheme .. " not found!")
        return
      end
    end
  '';
}
