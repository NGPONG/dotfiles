local execlude_fts = {
  'netrw',
  'help',
  'qf',
  'prompt',

  -- 'dap-repl',
  -- 'dapui_watches',
  -- 'dapui_hover',
  -- 'toggleterm',
  'TelescopePrompt',
  'neo-tree',
  'trouble',
  'ClangdTypeHierarchy',
  'ClangdAST',
  'lazy',
  'mason',
  'notify',
  'ngpong_popup',
  'neo-tree-popup',
}

local f = function(bufnr)
  return Tools.tbl_contains(execlude_fts, Helper.get_filetype(bufnr))
end

return setmetatable({}, {
  __call = function (self, ...)
    return f(...)
  end
})
