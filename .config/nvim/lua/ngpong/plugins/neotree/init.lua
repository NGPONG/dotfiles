return {
  'nvim-neo-tree/neo-tree.nvim',
  lazy = true,
  cmd = 'Neotree',
  init = function()
    Plgs.record_seq('neo-tree.nvim init')
    Plgs.neotree.keys.setup()
    Plgs.neotree.opts.setup()
  end,
  config = function()
    Plgs.record_seq('neo-tree.nvim config')
    Plgs.neotree.highlight.setup()
    Plgs.neotree.config.setup()
  end
}
