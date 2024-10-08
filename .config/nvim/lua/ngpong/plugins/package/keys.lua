local M = {}

local Keymap = require('ngpong.common.keybinder')

local e_mode = Keymap.e_mode

local del_native_keymaps = function()
end

local set_native_keymaps = function()
  Keymap.register(e_mode.NORMAL, '<leader>P', '<CMD>Mason<CR>', { remap = false, desc = 'open mason package manager.' })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()
end

return M
