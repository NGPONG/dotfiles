local M = {}

local colors = Plgs.colorscheme.colors

local setup = function()
  -- https://www.reddit.com/r/neovim/comments/xcsatv/how_can_i_configure_telescope_to_look_like_this/
  vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { fg = colors.bright_green, italic = true, bold = true })
  vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { fg = colors.bright_green, italic = true, bold = true })
  vim.api.nvim_set_hl(0, 'TelescopeMatching', { fg = colors.bright_red, italic = true, bold = true })
  vim.api.nvim_set_hl(0, 'TelescopeSelection', { bg = colors.dark2 })
  vim.api.nvim_set_hl(0, 'TelescopeSelectionCaret', { bg = colors.dark2, fg = colors.light1 })
  vim.api.nvim_set_hl(0, 'TelescopeMultiSelection', { fg = colors.light1, bg = colors.dark2, bold = true, italic = true })

  vim.api.nvim_set_hl(0, 'TelescopeResultsDiffUntracked', { fg = colors.bright_orange })
  vim.api.nvim_set_hl(0, 'TelescopeResultsDiffAdd', { fg = colors.bright_green })
  vim.api.nvim_set_hl(0, 'TelescopeResultsDiffchange', { fg = colors.bright_yellow })
  vim.api.nvim_set_hl(0, 'TelescopeResultsDiffDelete', { fg = colors.bright_red })
  -- vim.api.nvim_set_hl(0, 'TelescopeResultsDiffuntracked', { fg = colors.bright_red })

  -- vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = colors.gray })
  -- vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = colors.gray })
  -- vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { fg = colors.gray })
  -- vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { fg = colors.gray })

  -- vim.api.nvim_set_hl(0, 'TelescopeSelectionCaret', { fg = colors.bright_green, italic = true, bold = true })
  -- vim.api.nvim_set_hl(0, 'TelescopeMultiSelection', { fg = colors.bright_red })
  -- vim.api.nvim_set_hl(0, 'TelescopeSelection', { fg = colors.bright_blue, italic = true, bold = true })
end

M.setup = setup

return M
