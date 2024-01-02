local M = {}

------------------------------------------------------------------------------------------------
local f = function()
  local should_profile = os.getenv("NVIM_PROFILE")
  if should_profile then
    vim.keymap.set("", "<f1>", function()
      local prof = require("profile")
      if prof.is_recording() then
        prof.stop()
        vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
          if filename then
            prof.export(filename)
            vim.notify(string.format("Wrote %s", filename))
          end
        end)
      else
        prof.start("*")
      end
    end)

    require("profile").instrument_autocmds()
    if should_profile:lower():match("^start") then
      require("profile").start("*") -- *treesitter: 只监视 treesitter
    else
      require("profile").instrument("*")
    end
  end
end
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
local setup = function()
  f()
end
------------------------------------------------------------------------------------------------

M.setup = setup

return M

