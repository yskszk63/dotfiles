lua << EOF

vim.opt.mouse = ""
vim.opt.number = true
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
vim.opt.relativenumber = true
vim.opt.clipboard = vim.opt.clipboard + { "unnamedplus" }
vim.opt.sh = "zsh"
vim.opt.termguicolors = true

vim.g.vimsyn_embed = 'l'
vim.g.mapleader = ' '

-- keymap for terminal
vim.api.nvim_set_keymap('t', '<ESC>', [[<C-\><C-n>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '@t', [[:botright split<CR>:terminal<CR>i]], { noremap = true })
vim.api.nvim_set_keymap('n', '@T', [[:tabnew<CR>:terminal<CR>i]], { noremap = true })

require'packer'.startup(function()
  use'sainnhe/edge'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/plenary.nvim'}
    }
  }

  use'lambdalisue/battery.vim'
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons'}
  }
  use {'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}
  --use {
    --'romgrk/barbar.nvim',
    --requires = {'kyazdani42/nvim-web-devicons'}
  --}
  --use'beauwilliams/statusline.lua'

  use'preservim/nerdtree'
  use'Xuyuanp/nerdtree-git-plugin'

  use'yuttie/comfortable-motion.vim'

  use'cespare/vim-toml'
  use'rust-lang/rust.vim'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use'glepnir/indent-guides.nvim'

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

-- lualine
require'lualine'.setup {
  options = {
    theme = 'ayu_dark'
  },
  sections = {
    lualine_c = {'filename', vim.fn['battery#component']},
    lualine_x = {require'lsp-status'.status, 'encoding', 'fileformat', {'filetype',colored=false}},
    lualine_z = {'location', {'diagnostics', sources = {'nvim_lsp'}}}
  }
}
-- nvim-bufferline.lua
require("bufferline").setup {
  options = {
    diagnostics = "nvim_lsp",
  }
}

-- no term number
vim.cmd([[autocmd TermOpen * setlocal nonumber]])
vim.cmd([[autocmd TermOpen * setlocal norelativenumber]])
vim.cmd([[autocmd TermOpen * setlocal signcolumn=]])

-- NERDTree
vim.api.nvim_set_keymap('n', '<C-n>', [[:NERDTreeToggle<CR>]], { noremap = true, silent = true })
vim.g.NERDTreeGitStatusUseNerdFonts = 1
vim.g.NERDTreeGitStatusShowClean = 1

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
local servers = { }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

require'compe'.setup {
  enabled = true,
  source = {
    path = true,
    buffer = true,
    nvim_lsp = true,
  },
}

-- Map compe confirm and complete functions
vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")', { expr = true })
vim.api.nvim_set_keymap('i', '<c-space>', 'compe#complete()', { expr = true })

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

require'indent_guides'.setup {
  indent_start_level = 2,
  --indent_guide_size = 4,
  --even_colors = { fg ='#2a3834',bg='#332b36' },
  --odd_colors = {fg='#332b36',bg='#2a3834'},
}

EOF
" vim:set sw=2 ts=2 sts=2:
