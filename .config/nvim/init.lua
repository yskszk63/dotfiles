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
vim.opt.completeopt = {"menu", "menuone", "noselect"}
vim.opt.pumblend = 20
vim.opt.winblend = 20
vim.opt.clipboard = vim.opt.clipboard + {"unnamedplus"}
if vim.fn.executable("zsh") == 1 then vim.opt.sh = "zsh" end

-- Revert old behavior for https://github.com/neovim/neovim/pull/13268
vim.cmd [[nunmap Y]]

vim.g.vimsyn_embed = 'l'
vim.g.mapleader = [[ ]]

_G.reset_term_color = function()
  -- reset term color
  vim.b.terminal_color_foreground = '#B3B1AD'
  vim.b.terminal_color_background = '#0A0E14'
  vim.b.terminal_color_0 = '#01060E'
  vim.b.terminal_color_1 = '#EA6C73'
  vim.b.terminal_color_2 = '#91B362'
  vim.b.terminal_color_3 = '#F9AF4F'
  vim.b.terminal_color_4 = '#53BDFA'
  vim.b.terminal_color_5 = '#FAE994'
  vim.b.terminal_color_6 = '#90E1C6'
  vim.b.terminal_color_7 = '#C7C7C7'
  vim.b.terminal_color_8 = '#686868'
  vim.b.terminal_color_9 = '#F07178'
  vim.b.terminal_color_10 = '#C2D94C'
  vim.b.terminal_color_11 = '#FFB454'
  vim.b.terminal_color_12 = '#59C2FF'
  vim.b.terminal_color_13 = '#FFEE99'
  vim.b.terminal_color_14 = '#95E6CB'
  vim.b.terminal_color_15 = '#FFFFFF'
end
vim.cmd [[
  augroup mytermcolor
    autocmd!
    autocmd TermOpen * lua reset_term_color()
  augroup END
]]

_G.spliterm = function()
  local w = vim.fn.winwidth(0)
  if w > (80 * 2) then
    vim.api.nvim_exec([[
      rightbelow vsplit
      terminal
      startinsert
    ]], false)
  else
    vim.api.nvim_exec([[
      botright split
      terminal
      startinsert
    ]], false)
  end
end

-- keymap for terminal
vim.api.nvim_set_keymap('t', '<ESC>', [[<C-\><C-n>]],
                        {noremap = true, silent = true})
--vim.api.nvim_set_keymap('n', '@t', [[:botright split<CR>:terminal<CR>i]],
vim.api.nvim_set_keymap('n', '@t', [[:lua _G.spliterm()<CR>]],
                        {noremap = true})
vim.api.nvim_set_keymap('n', '@T', [[:tabnew<CR>:terminal<CR>i]],
                        {noremap = true})

-- no term number
vim.cmd [[autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no]]

vim.cmd [[autocmd FileType go setlocal noexpandtab]]

vim.cmd [[autocmd FileType typescript setlocal ts=2 sts=2 sw=2]]
vim.cmd [[autocmd FileType typescriptreact setlocal ts=2 sts=2 sw=2]]

vim.cmd [[autocmd FileType json setlocal ts=2 sts=2 sw=2]]
vim.cmd [[autocmd FileType html setlocal ts=2 sts=2 sw=2]]

-- Disalbe embedded plugins.

vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu   = 1
--vim.g.did_indent_on             = 1
--vim.g.did_load_filetypes        = 1
--vim.g.did_load_ftplugin         = 1
vim.g.loaded_2html_plugin       = 1
vim.g.loaded_gzip               = 1
--vim.g.loaded_man                = 1
vim.g.loaded_matchit            = 1
vim.g.loaded_matchparen         = 1
vim.g.loaded_netrwPlugin        = 1
vim.g.loaded_remote_plugins     = 1
vim.g.loaded_shada_plugin       = 1
vim.g.loaded_spellfile_plugin   = 1
vim.g.loaded_tarPlugin          = 1
vim.g.loaded_tutor_mode_plugin  = 1
vim.g.loaded_zipPlugin          = 1
vim.g.skip_loading_mswin        = 1

-- External packages.

-- packer.nvim wrapper.
vim.cmd [[command! PackerInstall call v:lua.prepare_packer() | lua require('packer').install()]]
vim.cmd [[command! PackerUpdate call v:lua.prepare_packer() | lua require('packer').update()]]
vim.cmd [[command! PackerSync call v:lua.prepare_packer() | lua require('packer').sync()]]
vim.cmd [[command! PackerClean call v:lua.prepare_packer() | lua require('packer').clean()]]
vim.cmd [[command! PackerCompile call v:lua.prepare_packer() | lua require('packer').compile()]]

_G.prepare_packer = function()
    -- packer.nvim bootstrap
    -- https://github.com/wbthomason/packer.nvim#bootstrapping
    local install_path = vim.fn.stdpath('data') ..
                             '/site/pack/packer/opt/packer.nvim'

    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system({
            'git', 'clone', 'https://github.com/wbthomason/packer.nvim',
            install_path
        })
    end
    vim.api.nvim_command 'packadd packer.nvim'

    require'packer'.startup(function()
        use {'wbthomason/packer.nvim', opt = true}

        use 'mattn/emmet-vim'

        use {
          'github/copilot.vim',
          opt = true,
          disable = vim.api.nvim_call_function('has', {'nvim-0.6'}) == 0,
          setup = function()
            vim.api.nvim_set_keymap('i', '<C-L>', 'copilot#Accept()', { script=true, silent=true, nowait=true, expr=true })
            vim.g.copilot_no_tab_map = true
          end
        }

        use {
          'vim-skk/skkeleton',
          requires = {
            'vim-denops/denops.vim',
            --'delphinus/skkeleton_indicator.nvim',
          },
          disable = vim.fn.executable("zsh") ~= 1,
          config = function()
            vim.api.nvim_set_keymap('i', '<C-j>', [[<Plug>(skkeleton-enable)]], {})
            vim.api.nvim_set_keymap('c', '<C-j>', [[<Plug>(skkeleton-enable)]], {})
            _G.skkeleton_init = function()
              vim.fn['skkeleton#config'] {
                tabCompletion = true,
                usePopup = true,
                --eggLikeNewline = true,
                --showCandidatesCount = 65535,
                markerHenkan = '﬍ ',
                markerHenkanSelect = 'ﳳ ',
                --markerHenkan = '',
                --markerHenkanSelect = '',
              }
              require'skkeleton_indicator'.setup{}
            end

            vim.cmd [[autocmd User skkeleton-initialize-pre lua _G.skkeleton_init()]]
          end
        }

        use {
            'sainnhe/sonokai',
            config = function()
                --vim.g.sonokai_style = 'andromeda'
                vim.g.sonokai_style = 'default'
                vim.g.sonokai_enable_italic = 1
                vim.g.sonokai_transparent_background = 1
                vim.g.sonokai_diagnostic_text_highlight = 1
                vim.g.sonokai_diagnostic_line_highlight = 1
                vim.g.sonokai_diagnostic_virtual_text = 'colored'

                vim.cmd([[colorscheme sonokai]])
            end
        }

        use {
            'nvim-telescope/telescope.nvim',
            requires = {'nvim-lua/plenary.nvim'},
            config = function()
                require'telescope'.setup {defaults = {color_devicons = false}}
                vim.api.nvim_set_keymap('n', '<C-p>',
                                        [[<cmd>lua require('telescope.builtin').find_files()<CR>]],
                                        {noremap = true})
                vim.api.nvim_set_keymap('n', '<Leader>b',
                                        [[<cmd>lua require('telescope.builtin').buffers()<cr>]],
                                        {noremap = true})
                vim.api.nvim_set_keymap('n', '<Leader>rg',
                                        [[<cmd>lua require('telescope.builtin').live_grep({ prompt_prefix="🔍" })<cr>]],
                                        {noremap = true})
            end
        }

				use {
						'hoob3rt/lualine.nvim',
						requires = {
								'kyazdani42/nvim-web-devicons',
								'lambdalisue/battery.vim',
								'nvim-lua/lsp-status.nvim',
						},
						config = function()
							require('lualine').setup{
									options = {
											theme = 'ayu_dark'
									},
                  sections = {
                      lualine_c = {'filename', 'battery#component', require'lsp-status'.status},
                  },
							}
						end
				}

        use {
            'alvarosevilla95/luatab.nvim',
            requires = 'kyazdani42/nvim-web-devicons',
            config = function()
                require('luatab').setup{}
            end
        }

        use {
            'kyazdani42/nvim-tree.lua',
            config = function()
                require'nvim-tree'.setup{}
                vim.api.nvim_set_keymap('n', '<C-n>', [[:NvimTreeToggle<CR>]],
                                        {noremap = true, silent = true})
            end
        }

        use 'yuttie/comfortable-motion.vim'

        use 'cespare/vim-toml'
        use 'rust-lang/rust.vim'
        use 'andrejlevkovitch/vim-lua-format'
        use 'ollykel/v-vim'

        use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

        use {
            'nvim-lua/lsp-status.nvim',
            config = function()
                require'lsp-status'.register_progress()
            end
        }

        use {'anekos/runes-vim', opts = true}

        use {
            'neovim/nvim-lspconfig',
            requires = {
                'nvim-lua/lsp-status.nvim', 'simrat39/rust-tools.nvim',
                'ray-x/lsp_signature.nvim',
            },
            config = function() _G.setup_lsp() end
        }

        use {
            'Saecki/crates.nvim',
            requires = { 'nvim-lua/plenary.nvim' },
            config = function()
                require('crates').setup {}
            end
        }

        use {
            'hrsh7th/nvim-cmp',
            requires = {
                'hrsh7th/cmp-nvim-lsp',
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                'onsails/lspkind-nvim',
                'Saecki/crates.nvim',
                'L3MON4D3/LuaSnip',
                'saadparwaiz1/cmp_luasnip',
                --'rinx/cmp-skkeleton',
                'hrsh7th/cmp-cmdline',
            },
            config = function()
                local cmp = require'cmp'
                local lspkind = require'lspkind'

                lspkind.init { }

                cmp.setup {
                    snippet = {
                      expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                        -- empty
                        -- Suppress error below.
                        -- 
                        -- E5108: Error executing lua ...te/pack/packer/start/nvim-cmp/lua/cmp/config/default.lua:26:
                        --   snippet engine is not configured.

                      end
                    },
                    mapping = {
                        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
                        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                        ['<C-e>'] = cmp.mapping({
                            i = cmp.mapping.abort(),
                            c = cmp.mapping.close(),
                        }),
                        ['<CR>'] = cmp.mapping.confirm({ select = true }),
                        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })
                    },
                    sources = cmp.config.sources({
                        { name = 'nvim_lsp' },
                        { name = 'buffer' },
                        { name = 'path' },
                        { name = "crates" },
                        --{ name = 'skkeleton' },
                    }, {
                        { name = 'buffer' },
                    }),

                    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
                    cmp.setup.cmdline('/', {
                        sources = {
                            { name = 'buffer' }
                        }
                    }),

                    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
                    cmp.setup.cmdline(':', {
                        sources = cmp.config.sources({
                            { name = 'path' }
                        }, {
                            { name = 'cmdline' }
                        })
                    }),

                    formatting = {
                        format = function(entry, vim_item)
                            vim_item.kind = lspkind.presets.default[vim_item.kind]
                            return vim_item
                        end
                    },
                    --[==[
                    experimental = {
                        native_menu = true
                    },
                    ]==]
                }
            end
        }
    end)
end

_G.setup_lsp = function()
    local configs = require'lspconfig/configs'
    local nvim_lsp = require'lspconfig'

    -- https://github.com/neovim/nvim-lspconfig#keybindings-and-completion

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
        local function buf_set_keymap(...)
            vim.api.nvim_buf_set_keymap(bufnr, ...)
        end
        local function buf_set_option(...)
            vim.api.nvim_buf_set_option(bufnr, ...)
        end

        -- Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = {noremap = true, silent = true}

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        --buf_set_keymap('n', 'gd', '<cmd>tab split | lua vim.lsp.buf.definition()<cr>', opts)
        buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>',
                       opts)
        buf_set_keymap('n', '<C-k>',
                       '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>wa',
                       '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wr',
                       '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
                       opts)
        buf_set_keymap('n', '<space>wl',
                       '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                       opts)
        buf_set_keymap('n', '<space>D',
                       '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',
                       opts)
        buf_set_keymap('n', '<space>ca',
                       '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>e',
                       '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
                       opts)
        buf_set_keymap('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
                       opts)
        buf_set_keymap('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
                       opts)
        buf_set_keymap('n', '<space>q',
                       '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>',
                       opts)

        -- added
        require'lsp-status'.on_attach(client, bufnr)
        -- nvim-cmp
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
        -- lsp_signature
        require "lsp_signature".on_attach({
            bind = true,
            handler_opts = {
                border = "double"
            },
            hint_prefix = "💡 ",
        }, bufnr)
    end

    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    local servers = {'gopls', 'tsserver'}
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            on_attach = on_attach,
            capabilities = require'lsp-status'.capabilities,
            flags = {debounce_text_changes = 150},
            autostart = false,
        }
    end

    nvim_lsp.java_language_server.setup {
        cmd = { "java-language-server" },
        settings = {
            java = {
                home = "/home/yskszk63/.asdf/installs/java/openjdk-17.0.1",
                --addExports = { "jdk.incubator.foreign/jdk.incubator.foreign" },
            },
        },
        on_attach = on_attach,
        capabilities = require'lsp-status'.capabilities,
    }

    nvim_lsp.denols.setup {
        cmd = { "deno-lsp"},
        --cmd = { "deno", "lsp", "--unstable", "-Ldebug"},
        on_attach = on_attach,
        capabilities = require'lsp-status'.capabilities,
        --autostart = false,
        flags = {debounce_text_changes = 150}
    }

    require'rust-tools'.setup {
        autostart = false,
        server = {
            on_attach = on_attach,
            flags = {debounce_text_changes = 150},
            settings = {["rust-analyzer"] = {diagnostics = {enable = false}}}
        }
    }

    -- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#change-diagnostic-symbols-in-the-sign-column-gutter
    local signs = {
        Error = " ",
        Warning = " ",
        Hint = " ",
        Information = " "
    }

    for type, icon in pairs(signs) do
        local hl = "LspDiagnosticsSign" .. type
        vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ""})
    end
end

-- vim:set sw=2 ts=2 sts=2:
