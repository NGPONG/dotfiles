local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
  vim.api.nvim_set_hl(0, 'LeapMatch', { fg = 'white', bold = true, underline = true, nocombine = true, })
end

return M