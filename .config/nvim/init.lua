vim.opt.mouse = ""
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes:1'
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.pumblend = 20
vim.opt.winblend = 20
vim.opt.clipboard = vim.opt.clipboard + { "unnamedplus" }
vim.opt.sh = "zsh"

vim.g.vimsyn_embed = 'l'
vim.g.mapleader = ' '

-- keymap for terminal
vim.api.nvim_set_keymap('t', '<ESC>', [[<C-\><C-n>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '@t', [[:botright split<CR>:terminal<CR>i]], { noremap = true })
vim.api.nvim_set_keymap('n', '@T', [[:tabnew<CR>:terminal<CR>i]], { noremap = true })

-- no term number
vim.cmd([[autocmd TermOpen * setlocal nonumber]])
vim.cmd([[autocmd TermOpen * setlocal norelativenumber]])
vim.cmd([[autocmd TermOpen * setlocal signcolumn=]])

-- https://github.com/wbthomason/packer.nvim#bootstrapping
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.api.nvim_command 'packadd packer.nvim'
end

require'packer'.startup(function()
  use 'wbthomason/packer.nvim'

  use'sainnhe/edge'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/plenary.nvim'}
  }

  use'lambdalisue/battery.vim'
  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }
  use {
    'akinsho/nvim-bufferline.lua',
    requires = 'kyazdani42/nvim-web-devicons'
  }

  use'kyazdani42/nvim-tree.lua'

  use'yuttie/comfortable-motion.vim'

  use'cespare/vim-toml'
  use'rust-lang/rust.vim'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use'neovim/nvim-lspconfig'
  use'nvim-lua/lsp-status.nvim'
  use'hrsh7th/nvim-compe'
  use'simrat39/rust-tools.nvim'
end)

-- Theme
vim.g.edge_style = 'aura'
vim.g.edge_enable_italic = 1
vim.g.edge_disable_italic_comment = 0
vim.g.edge_transparent_background = 1
vim.g.edge_diagnostic_text_highlight = 1
vim.g.edge_diagnostic_virtual_text = 'colored'

vim.cmd([[colorscheme edge]])

-- Telescope
require'telescope'.setup {
  defaults = {
    color_devicons = false
  }
}
vim.api.nvim_set_keymap('n', '<C-p>', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>b', [[<cmd>lua require('telescope.builtin').buffers()<cr>]], { noremap = true })

-- galaxyline
local setup_galaxyline = function(gl)
  local gls = gl.section
  gl.short_line_list = { 'NvimTree' }
  
  local colors = {
    bg = '#282c34',
    yellow = '#fabd2f',
    cyan = '#008080',
    darkblue = '#081633',
    green = '#afd700',
    orange = '#FF8800',
    purple = '#5d4d7a',
    magenta = '#d16d9e',
    grey = '#c0c0c0',
    blue = '#0087d7',
    red = '#ec5f67'
  }
  
  local buffer_not_empty = function()
    if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
      return true
    end
    return false
  end

  gls.left[1] = {
    FirstElement = {
      provider = function() return ' ' end,
      highlight = { colors.purple, colors.purple }
    },
  }
  gls.left[2] = {
    ViMode = {
      provider = function()
        -- https://github.com/hoob3rt/lualine.nvim/blob/9726824f1dcc8907632bc7c32f9882f26340f815/lua/lualine/utils/mode.lua#L5
        local alias = {
          ['n']    = 'NORMAL',
          ['no']   = 'O-PENDING',
          ['nov']  = 'O-PENDING',
          ['noV']  = 'O-PENDING',
          ['no'] = 'O-PENDING',
          ['niI']  = 'NORMAL',
          ['niR']  = 'NORMAL',
          ['niV']  = 'NORMAL',
          ['v']    = 'VISUAL',
          ['V']    = 'V-LINE',
          ['']   = 'V-BLOCK',
          ['s']    = 'SELECT',
          ['S']    = 'S-LINE',
          ['']   = 'S-BLOCK',
          ['i']    = 'INSERT',
          ['ic']   = 'INSERT',
          ['ix']   = 'INSERT',
          ['R']    = 'REPLACE',
          ['Rc']   = 'REPLACE',
          ['Rv']   = 'V-REPLACE',
          ['Rx']   = 'REPLACE',
          ['c']    = 'COMMAND',
          ['cv']   = 'EX',
          ['ce']   = 'EX',
          ['r']    = 'REPLACE',
          ['rm']   = 'MORE',
          ['r?']   = 'CONFIRM',
          ['!']    = 'SHELL',
          ['t']    = 'TERMINAL',
        }
        local code = vim.api.nvim_get_mode().mode
        if alias[code] == nil then
          return code .. ' '
        end
        return alias[code] .. ' '
      end,
      separator = ' ',
      separator_highlight = {colors.purple,function()
        if not buffer_not_empty() then
          return colors.purple
        end
        return colors.darkblue
      end},
      highlight = {colors.darkblue,colors.purple,'bold'},
    },
  }
  gls.left[3] ={
    FileIcon = {
      provider = 'FileIcon',
      condition = buffer_not_empty,
      highlight = { colors.purple ,colors.darkblue },
    },
  }
  gls.left[4] = {
    FileName = {
      provider = 'FileName',
      condition = buffer_not_empty,
      separator = '',
      separator_highlight = {colors.purple,colors.darkblue},
      highlight = { colors.magenta,colors.darkblue }
    }
  }
  
  gls.left[5] = {
    GitIcon = {
      provider = function() return '  ' end,
      condition = buffer_not_empty,
      highlight = { colors.orange, colors.darkblue },
    }
  }
  gls.left[6] = {
    GitBranch = {
      provider = 'GitBranch',
      condition = buffer_not_empty,
      highlight = { colors.magenta, colors.darkblue },
    }
  }
  
  gls.left[10] = {
    LeftEnd = {
      provider = function() return ' ' end,
      separator = ' ',
      separator_highlight = { colors.darkblue, colors.bg },
      highlight = { colors.darkblue, colors.darkblue }
    }
  }
  gls.left[11] = {
    DiagnosticError = {
      provider = 'DiagnosticError',
      icon = '  ',
      highlight = { colors.red, colors.bg }
    }
  }
  gls.left[12] = {
    Space = {
      provider = function () return ' ' end,
      highlight = { colors.bg, colors.bg }
    }
  }
  gls.left[13] = {
    DiagnosticWarn = {
      provider = 'DiagnosticWarn',
      icon = '  ',
      highlight = { colors.blue, colors.bg }
    }
  }
  gls.left[14] = {
    Battery = {
      provider = vim.fn['battery#component'],
      separator = '|',
      separator_highlight = {colors.darkblue,colors.bg},
      highlight = { colors.darkblue, colors.bg }
    }
  }
  gls.left[15] = {
    LspStatus = {
      provider = require'lsp-status'.status,
      highlight = { colors.darkblue, colors.bg }
    }
  }

  gls.right[1]= {
    FileFormat = {
      provider = 'FileFormat',
      separator = ' ',
      separator_highlight = {colors.bg,colors.darkblue},
      highlight = {colors.magenta,colors.darkblue},
    }
  }
  gls.right[2]= {
    FileEncode = {
      provider = 'FileEncode',
      separator = ' |',
      separator_highlight = {colors.darkblue,colors.darkblue},
      highlight = {colors.magenta,colors.darkblue},
    }
  }
  gls.right[3] = {
    LineInfo = {
      provider = 'LineColumn',
      separator = ' |',
      separator_highlight = {colors.darkblue,colors.darkblue},
      highlight = {colors.magenta,colors.darkblue},
    },
  }
  gls.right[4] = {
    ScrollBar = {
      provider = 'ScrollBar',
      highlight = {colors.orange,colors.darkblue},
    }
  }
  
  gls.short_line_left[1] = {
    BufferType = {
      provider = 'FileTypeName',
      separator = ' ',
      separator_highlight = {colors.purple,colors.bg},
      highlight = {colors.grey,colors.purple}
    }
  }
  
  gls.short_line_right[1] = {
    BufferIcon = {
      provider= 'BufferIcon',
      separator = ' ',
      separator_highlight = {colors.purple,colors.bg},
      highlight = {colors.grey,colors.purple}
    }
  }
end
setup_galaxyline(require'galaxyline')

-- nvim-bufferline.lua
require("bufferline").setup {
  options = {
    diagnostics = "nvim_lsp",
  }
}

-- NvimTree
vim.api.nvim_set_keymap('n', '<C-n>', [[:NvimTreeToggle<CR>]], { noremap = true, silent = true })

-- lsp
local lsp_status = require'lsp-status'
lsp_status.register_progress()

local nvim_lsp = require('lspconfig')

-- https://github.com/neovim/nvim-lspconfig#keybindings-and-completion

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  -- added
  lsp_status.on_attach(client, bufnr)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'gopls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

-- rust-tools
require'rust-tools'.setup {
  server = {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      ["rust-analyzer"] = {
        diagnostics = {
          enable = false
        }
      }
    }
  }
}

-- compe
require'compe'.setup {
  enabled = true,
  autocomplete = true,
  source = {
    path = true,
    buffer = true,
    nvim_lsp = true,
  },
  preselect = 'always',
  documentation = {border = 'single'},
}

-- Map compe confirm and complete functions
vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")', { expr = true })
vim.api.nvim_set_keymap('i', '<c-space>', 'compe#complete()', { expr = true })

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#change-diagnostic-symbols-in-the-sign-column-gutter
local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- vim:set sw=2 ts=2 sts=2: