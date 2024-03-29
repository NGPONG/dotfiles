local M = {}

local lazy           = require('ngpong.utils.lazy')
local state          = lazy.require('telescope.state')
local builtin        = lazy.require('telescope.builtin')
local actions        = lazy.require('telescope.actions')
local actions_set    = lazy.require('telescope.actions.set')
local actions_state  = lazy.require('telescope.actions.state')
local actions_layout = lazy.require('telescope.actions.layout')
local resolver       = lazy.require('telescope.config.resolve')
local multiselect    = lazy.require('telescope.pickers.multi')

M.actions = setmetatable({}, {
  __index = function(t, k)
    return lazy.access('telescope.actions', k)
  end
})

M.get_current_picker = function(bufnr)
  return actions_state.get_current_picker(bufnr)
end

M.append_to_history = function(bufnr)
  local picker = actions_state.get_current_picker(bufnr)
  if picker == nil then
    return
  end

  local line = actions_state.get_current_line()
  if TOOLS.isempty(line) then
    return
  end

  actions_state.get_current_history():append(line, picker)
end

M.close_telescope = function()
  return function(bufnr)
    M.append_to_history(bufnr)
    actions.close(bufnr)
  end
end

M.toggle_preview = function(bufnr)
  actions_layout.toggle_preview(bufnr)
end

M.delete_entries = function(bufnr)
  -- copy from telescope.picker.delete_selection

  local picker = M.get_current_picker(bufnr)
  if not picker then
    return
  end

  local original_selection_strategy = picker.selection_strategy
  picker.selection_strategy = "row"

  local delete_selections = picker._multi:get()
  local used_multi_select = true
  if vim.tbl_isempty(delete_selections) then
    table.insert(delete_selections, picker:get_selection())
    used_multi_select = false
  end

  local selection_index = {}
  for result_index, result_entry in ipairs(picker.finder.results) do
    if vim.tbl_contains(delete_selections, result_entry) then
      table.insert(selection_index, result_index)
    end
  end

  -- Sort in reverse order as removing an entry from the table shifts down the
  -- other elements to close the hole.
  table.sort(selection_index, function(x, y)
    return x > y
  end)
  for _, index in ipairs(selection_index) do
    local delete_bufnr = picker.finder.results[index].bufnr

    if HELPER.delete_buffer(delete_bufnr, false, function()
      return not PLGS.bufferline.api.is_pinned(delete_bufnr)
    end) then
      table.remove(picker.finder.results, index)
    end
  end

  if used_multi_select then
    picker._multi = multiselect:new()
  end

  picker:refresh()
  vim.defer_fn(function()
    picker.selection_strategy = original_selection_strategy
  end, 50)
end

M.select_entries = function(bufnr)
  local picker = actions_state.get_current_picker(bufnr)
  if not picker then
    return
  end

  if next(picker:get_multi_selection()) ~= nil then
    local wrap = TOOLS.wrap_f

    local handler = wrap(HELPER.clear_qflst, picker.original_win_id) +
                    wrap(actions.send_selected_to_qflist) +
                    wrap(PLGS.trouble.api.open, 'quickfix', 'Telescope entries selected')
    if not handler then
      return
    end

    handler(bufnr)
  else
    actions.select_default(bufnr)
    vim.schedule(HELPER.keep_screen_center)
  end
end

M.get_prompt_init_pos = function()
  return 1, 5
end

M.reset_prompt_pos = function()
  HELPER.set_cursor(M.get_prompt_init_pos())
end

M.keep_cursor_outof_range = function(key)
  local _, col = M.get_prompt_init_pos()

  return function(...)
    local _, cur = HELPER.get_cursor()

    if cur == col then
      return
    else
      if key ~= nil then
        HELPER.feedkeys(key)
      else
        M.reset_prompt_pos()
      end
    end
  end
end

M.scroll_result = function(direction, speed)
  -- REF: telescope.nvim/lua/telescope/actions/set.lua::scroll_results
  return function(bufnr)
    local status = state.get_status(bufnr)

    local input = direction > 0 and [[]] or [[]]

    vim.api.nvim_win_call(status.layout.results.winid, function()
      vim.cmd([[normal! ]] .. math.floor(speed) .. input)
    end)

    actions_set.shift_selection(bufnr, math.floor(speed) * direction)
  end
end

M.scroll_preview = function(direction, speed)
  -- REF: telescope.nvim/lua/telescope/actions/set.lua::scroll_previewer
  return function(bufnr)
    local previewer = actions_state.get_current_picker(bufnr).previewer
    local status = state.get_status(bufnr)

    local preview_winid = status.layout.preview and status.layout.preview.winid
    if type(previewer) ~= "table" or previewer.scroll_fn == nil or preview_winid == nil then
      return
    end

    previewer:scroll_fn(math.floor(speed * direction))
  end
end

M.resolve_width = function(val)
  return resolver.resolve_width(val)
end

M.resolve_height = function(val)
  return resolver.resolve_height(val)
end

M.is_prompt_buf = function(bufnr)
  if not HELPER.is_buf_valid(bufnr) then
    return false
  end

  -- require "telescope.state".get_existing_prompt_bufnrs()
  return vim.api.nvim_buf_get_option(bufnr, 'filetype') == 'TelescopePrompt'
end

M.builtin_picker = function(picker, opts)
  local f = builtin[picker]
  if f ~= nil and type(f) == 'function' then
    f(opts)
  end
end

return M
