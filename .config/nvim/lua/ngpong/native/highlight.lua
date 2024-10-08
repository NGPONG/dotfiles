local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, 'NGPONGHiddenCursor', { reverse = true, blend = 100 })
  vim.api.nvim_set_hl(0, 'NGPONGHiddenCursor', { reverse = true, blend = 100 })

  vim.schedule(function()
    vim.api.nvim_set_hl(0, 'CursorLineNr', { link = 'GruvboxYellow' })
  end)
end

return M
