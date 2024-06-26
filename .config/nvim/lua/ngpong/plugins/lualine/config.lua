local M = {}

local Events = require('ngpong.common.events')
local Icons = require('ngpong.utils.icon')
local Lazy = require('ngpong.utils.lazy')
local Lualine = Lazy.require('lualine')

local this = Plgs.lualine
local mc = Plgs.multicursors
local colors = Plgs.colorscheme.colors
local trouble = Plgs.trouble

local e_name = Events.e_name

local module = {
  space = {
    function()
      return Icons.space
    end,
    padding = {
      left = 0,
      right = 0,
    },
  },
  mode_1 = {
    function()
      return '('
    end,
    component_name = 'mode_1',
    color = { gui = 'bold', fg = colors.dark0 },
    padding = {
      left = 1,
      right = 1,
    },
    separator = { left = Icons.left_half_1 },
  },
  mode_2 = {
    function()
      return Icons.rabbit
    end,
    component_name = 'mode_2',
    color = { fg = '#ffffff' },
    padding = {
      left = 0,
      right = 1,
    },
  },
  mode_3 = {
    function()
      return Icons.cat
    end,
    component_name = 'mode_3',
    color = { fg = colors.dark0 },
    padding = {
      left = 0,
      right = 1,
    },
  },
  mode_4 = {
    function()
      return Icons.cat
    end,
    component_name = 'mode_4',
    color = { fg = '#f2d896' },
    padding = {
      left = 0,
      right = 1,
    },
  },
  mode_5 = {
    function()
      return ')'
    end,
    component_name = 'mode_5',
    color = { gui = 'bold', fg = colors.dark0 },
    padding = {
      left = 0,
      right = 1,
    },
  },
  mode_6 = {
    'mode',
    fmt = function(str)
      if mc.api.is_active() then
        return '󰳽'
      else
        return str:sub(1, 1)
      end
    end,
    component_name = 'mode_6',
    separator = { right = Icons.right_half_1 },
    color = { gui = 'italic,bold', fg = colors.dark0 },
    padding = {
      left = 0,
      right = 1,
    },
  },
  git_1 = {
    'branch',
    component_name = 'git_1',
    icon = { Icons.git, color = { fg = colors.bright_orange } },
    padding = {
      left = 1,
      right = 1,
    },
    color = { bg = colors.dark3, fg = colors.light1 },
    separator = { left = Icons.left_half_1, right = Icons.right_half_1 },
  },
  git_2 = {
    'diff',
    component_name = 'git_2',
    symbols = {
      added = Icons.git_add .. Icons.space,
      modified = Icons.git_change .. Icons.space,
      removed = Icons.git_delete .. Icons.space,
    },
    padding = {
      left = 0,
      right = 1,
    },
    source = function()
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
        return {
          added = gitsigns.added,
          modified = gitsigns.changed,
          removed = gitsigns.removed,
        }
      end
    end,
  },
  lsp_1 = {
    function()
      local clis = vim.lsp.get_clients({ bufnr = Helper.get_cur_bufnr() })
      if next(clis) then
        return clis[1].name
      else
        return ''
      end
    end,
    component_name = 'lsp_1',
    icon = { Icons.activets, color = { fg = colors.bright_green } },
    padding = {
      left = 1,
      right = 1,
    },
    color = { bg = colors.dark2, fg = colors.light1 },
    separator = { left = Icons.left_half_1, right = Icons.right_half_1 },
  },
  lsp_2 = {
    'diagnostics',
    component_name = 'lsp_2',
    padding = {
      left = 0,
      right = 1,
    },
    sources = { 'nvim_diagnostic' },
    sections = { 'error', 'warn', 'info', 'hint' },
    symbols = {
      error = Icons.diagnostic_err .. Icons.space,
      warn = Icons.diagnostic_warn .. Icons.space,
      info = Icons.diagnostic_info .. Icons.space,
      hint = Icons.diagnostic_hint .. Icons.space,
    },
    color = { bg = colors.dark1 },
    colored = true,
    update_in_insert = false,
    always_visible = false,
  },
  filetype = {
    'filetype',
    component_name = 'filetype',
    padding = {
      left = 0,
      right = 1,
    },
    colored = false,
    color = { fg = colors.dark4, gui = 'italic' },
  },
  fileformat = {
    function()
      local format = vim.bo.fileformat

      if format == 'unix' then
        return Icons.unix .. Icons.space .. format
      elseif format == 'dos' then
        return Icons.windows .. Icons.space .. format
      elseif format == 'mac' then
        return Icons.mac .. Icons.space .. format
      else
        return ''
      end
    end,
    component_name = 'fileformat',
    padding = {
      left = 0,
      right = 1,
    },
    color = { fg = colors.dark4, gui = 'italic' },
  },
  encoding = {
    function()
      return Icons.files_2 .. Icons.space .. vim.opt.fileencoding:get()
    end,
    component_name = 'encoding',
    padding = {
      left = 0,
      right = 1,
    },
    color = { fg = colors.dark4, gui = 'italic' },
  },
  searchcount_1 = {
    'searchcount',
    component_name = 'searchcount',
    icon = { Icons.search, color = { fg = colors.bright_yellow } },
    padding = {
      left = 0,
      right = 0,
    },
    separator = { left = Icons.left_half_1, right = Icons.right_half_1 },
    color = { fg = colors.light1, bg = colors.dark2 },
  },
  searchcount_2 = {
    function()
      return Icons.space
    end,
    component_name = 'searchcount_2',
    cond = function()
      return vim.fn.getreg('/') ~= ''
    end,
    padding = {
      left = 0,
      right = 0,
    },
  },
  datetime = {
    function()
      return os.date('%A %H:%M')
    end,
    icon = { Icons.alarm, color = { fg = colors.bright_aqua } },
    component_name = 'datetime',
    padding = {
      left = 0,
      right = 0,
    },
    separator = { left = Icons.left_half_1, right = Icons.right_half_1 },
    color = { fg = colors.light1, bg = colors.dark2, gui = 'italic' },
  },
  progress_2 = {
    'progress',
    component_name = 'progress_2',
    padding = {
      left = 1,
      right = 0,
    },
    color = { bg = colors.dark2, fg = colors.bright_yellow },
  },
  progress_1 = {
    function()
      -- return '%#GruvboxPurple#%#GruvboxPurple#%#GruvboxPurple# 1' -- 设置颜色的方法
      return Icons.progress
    end,
    component_name = 'progress_1',
    padding = {
      left = 0,
      right = 1,
    },
    separator = { left = Icons.left_half_1 },
    color = { bg = colors.bright_yellow },
  },
  location_2 = {
    function()
      local line = vim.fn.line('.')
      local col = vim.fn.virtcol('.')
      return string.format('%3d:%-3d', line, col)
    end,
    component_name = 'location_2',
    padding = {
      left = 1,
      right = 1,
    },
    color = { bg = colors.dark2, fg = colors.bright_green },
  },
  location_1 = {
    function()
      return Icons.location
    end,
    component_name = 'location_1',
    padding = {
      left = 0,
      right = 1,
    },
    separator = { left = Icons.left_half_1 },
    color = { bg = colors.bright_green },
  },
  touble_type = {
    function()
      return trouble.api.get_cur_view_name()
    end,
    component_name = 'touble_type',
    color = { gui = 'italic,bold', fg = colors.dark0 },
    padding = {
      left = 1,
      right = 1,
    },
    separator = { left = Icons.left_half_1, right = Icons.right_half_1 },
  },
  clangd_extensions = function(source)
    return {
      function()
        return source
      end,
      component_name = 'clangd_extensions',
      color = { gui = 'italic,bold', fg = colors.dark0 },
      padding = {
        left = 1,
        right = 1,
      },
      separator = { left = Icons.left_half_1, right = Icons.right_half_1 },
    }
  end,
  lazy_indicator = {
    function()
      return 'Lazy plugins manager'
    end,
    component_name = 'lazy_indicator',
    color = { gui = 'italic,bold', fg = colors.dark0 },
    padding = {
      left = 1,
      right = 1,
    },
    separator = { left = Icons.left_half_1, right = Icons.right_half_1 },
  },
  mason_indicator = {
    function()
      return 'Mason package manager'
    end,
    component_name = 'mason_indicator',
    color = { gui = 'italic,bold', fg = colors.dark0 },
    padding = {
      left = 1,
      right = 1,
    },
    separator = { left = Icons.left_half_1, right = Icons.right_half_1 },
  },
}

local extension = {
  telescope = {
    sections = {
      lualine_a = {
        module.mode_1,
        module.mode_2,
        module.mode_3,
        module.mode_4,
        module.mode_5,
        module.mode_6,
      },
      lualine_x = {
        module.filetype,
        module.datetime,
      },
      lualine_y = {
        module.space,
      },
      lualine_z = {
        module.location_1,
        module.location_2,
        module.progress_1,
        module.progress_2,
      },
    },
    filetypes = { 'TelescopePrompt' },
  },
  neotree = {
    sections = {
      lualine_a = {
        module.mode_1,
        module.mode_2,
        module.mode_3,
        module.mode_4,
        module.mode_5,
        module.mode_6,
      },
      lualine_x = {
        module.filetype,
        module.searchcount_1,
        module.searchcount_2,
        module.datetime,
      },
      lualine_y = {
        module.space,
      },
      lualine_z = {
        module.location_1,
        module.location_2,
        module.progress_1,
        module.progress_2,
      },
    },
    filetypes = { 'neo-tree' },
  },
  trouble = {
    sections = {
      lualine_a = {
        module.touble_type,
      },
      lualine_x = {
        module.searchcount_1,
        module.searchcount_2,
        module.datetime,
      },
      lualine_y = {
        module.space,
      },
      lualine_z = {
        module.location_1,
        module.location_2,
        module.progress_1,
        module.progress_2,
      },
    },
    filetypes = { 'trouble' },
  },
  clangd_typehierarchy = {
    sections = {
      lualine_a = {
        module.clangd_extensions('Clangd type hierarchy'),
      },
      lualine_x = {
        module.searchcount_1,
        module.searchcount_2,
        module.datetime,
      },
      lualine_y = {
        module.space,
      },
      lualine_z = {
        module.location_1,
        module.location_2,
        module.progress_1,
        module.progress_2,
      },
    },
    filetypes = { 'ClangdTypeHierarchy' },
  },
  lazy = {
    sections = {
      lualine_a = {
        module.lazy_indicator,
      },
      lualine_x = {
        module.searchcount_1,
        module.searchcount_2,
        module.datetime,
      },
      lualine_y = {
        module.space,
      },
      lualine_z = {
        module.location_1,
        module.location_2,
        module.progress_1,
        module.progress_2,
      },
    },
    filetypes = { 'lazy' },
  },
  mason = {
    sections = {
      lualine_a = {
        module.mason_indicator,
      },
      lualine_x = {
        module.searchcount_1,
        module.searchcount_2,
        module.datetime,
      },
      lualine_y = {
        module.space,
      },
      lualine_z = {
        module.location_1,
        module.location_2,
        module.progress_1,
        module.progress_2,
      },
    },
    filetypes = { 'mason' },
  },
}

M.setup = function()
  local cfg = {
    options = {
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = {}, -- only ignores the ft for statusline.
        winbar = {}, -- only ignores the ft for winbar.
      },
      always_divide_middle = true,
      globalstatus = true,
      refresh = {
        statusline = 2000,
        tabline = 2000,
        winbar = 2000,
      },
    },
  }

  local theme_cfg = {
    options = {
      theme = {
        normal = {
          a = { bg = colors.bright_blue, fg = colors.dark0 },
          b = { bg = colors.dark1, fg = colors.light4 },
          c = { bg = colors.dark1, fg = colors.light4 },
        },
        insert = {
          a = { bg = colors.bright_red, fg = colors.dark0 },
          b = { bg = colors.dark1, fg = colors.light4 },
          c = { bg = colors.dark1, fg = colors.light4 },
        },
        visual = {
          a = { bg = colors.bright_orange, fg = colors.dark0 },
          b = { bg = colors.dark1, fg = colors.light4 },
          c = { bg = colors.dark1, fg = colors.light4 },
        },
        replace = {
          a = { bg = colors.dark1, fg = colors.dark0 },
          b = { bg = colors.dark1, fg = colors.light4 },
          c = { bg = colors.dark1, fg = colors.light4 },
        },
        command = {
          a = { bg = colors.bright_green, fg = colors.dark0 },
          b = { bg = colors.dark1, fg = colors.light4 },
          c = { bg = colors.dark1, fg = colors.light4 },
        },
        inactive = {
          a = { bg = colors.dark1, fg = colors.light4 },
          b = { bg = colors.dark1, fg = colors.light4 },
          c = { bg = colors.dark1, fg = colors.light4 },
        },
      },
    },
  }

  local extensions_cfg = {
    extensions = {
      extension.telescope,
      extension.neotree,
      extension.trouble,
      extension.clangd_typehierarchy,
      extension.lazy,
      extension.mason,
    },
  }

  local inactive_section_cfg = {
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  }

  local active_section_cfg = {
    sections = {
      lualine_a = {
        module.mode_1,
        module.mode_2,
        module.mode_3,
        module.mode_4,
        module.mode_5,
        module.mode_6,
        module.git_1,
        module.lsp_1,
      },
      lualine_b = {
        module.space,
      },
      lualine_c = {
        module.git_2,
        module.lsp_2,
      },
      lualine_x = {
        module.filetype,
        module.fileformat,
        module.encoding,
        module.searchcount_1,
        module.searchcount_2,
        module.datetime,
      },
      lualine_y = {
        module.space,
      },
      lualine_z = {
        module.location_1,
        module.location_2,
        module.progress_1,
        module.progress_2,
      },
    },
  }

  -- stylua: ignore
  Tools.tbl_r_extend(cfg, theme_cfg,
                          active_section_cfg,
                          inactive_section_cfg,
                          extensions_cfg)

  Events.emit(e_name.SETUP_LUALINE, cfg)

  Lualine.setup(cfg)
end

return M
