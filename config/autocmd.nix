{
  config.autoCmd = [
    {
      event = "TextYankPost";
      pattern = "*";
      desc = "Highlight text on yank";
      callback.__raw = ''
          function()
        vim.highlight.on_yank { higroup = "Search", timeout = 100 }
        end
      '';
    }
  ];
}
