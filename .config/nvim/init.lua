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
vim.opt.completeopt = {"menuone", "noselect"}
vim.opt.pumblend = 20
vim.opt.winblend = 20
vim.opt.clipboard = vim.opt.clipboard + {"unnamedplus"}
if vim.fn.executable("zsh") == 1 then vim.opt.sh = "zsh" end

vim.g.vimsyn_embed = 'l'
vim.g.mapleader = [[ ]]

-- keymap for terminal
vim.api.nvim_set_keymap('t', '<ESC>', [[<C-\><C-n>]],
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '@t', [[:botright split<CR>:terminal<CR>i]],
                        {noremap = true})
vim.api.nvim_set_keymap('n', '@T', [[:tabnew<CR>:terminal<CR>i]],
                        {noremap = true})

-- no term number
vim.cmd [[autocmd TermOpen * setlocal nonumber]]
vim.cmd [[autocmd TermOpen * setlocal norelativenumber]]
vim.cmd [[autocmd TermOpen * setlocal signcolumn=]]

vim.cmd [[autocmd FileType go setlocal noexpandtab]]

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

        use 'seandewar/nvimesweeper'

        --use 'sunjon/extmark-toy.nvim'

        use {
          'kuuote/denops-skkeleton.vim',
          requires = {
            'vim-denops/denops.vim'
          },
          config = function()
            vim.api.nvim_set_keymap('i', '<C-j>', [[<Plug>(skkeleton-toggle)]], {})
            vim.api.nvim_set_keymap('c', '<C-j>', [[<Plug>(skkeleton-toggle)]], {})
            vim.fn['skkeleton#config'] {
              eggLikeNewline = true,
              showCandidatesCount = 0,
            }
          end
        }

        use {
            'sainnhe/sonokai',
            config = function()
                vim.g.sonokai_style = 'andromeda'
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

        --[[
        use {
            'glepnir/galaxyline.nvim',
            branch = 'main',
            requires = {
                'kyazdani42/nvim-web-devicons', 'lambdalisue/battery.vim',
                'nvim-lua/lsp-status.nvim'
            },
            config = function()
                _G.setup_galaxyline(require 'galaxyline')
            end
        }
        ]]
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
                vim.o.tabline = [[%!v:lua.require'luatab'.tabline()]]
            end
        }

        use {
            'kyazdani42/nvim-tree.lua',
            config = function()
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
                --'onsails/lspkind-nvim'
            },
            config = function() _G.setup_lsp() end
        }

        use {
            'Shougo/ddc.vim',
            requires = {
                'vim-denops/denops.vim',
                'Shougo/ddc-nvim-lsp',
                'matsui54/ddc-nvim-lsp-doc',
                'Shougo/ddc-around',
            },
            config = function()
                vim.api.nvim_set_keymap('i', '<c-space>', 'ddc#manual_complete()',
                                        {expr = true, noremap = true})
                vim.fn['ddc#custom#patch_global']('sources', {'nvimlsp', 'skkeleton', 'around'})
                vim.fn['ddc#custom#patch_global']('sourceOptions', {
                    ['_'] = {
                        matchers = {'matcher_head'},
                        sorters = {'sorter_rank'},
                    },
                    nvimlsp = {
                        mark = 'lsp',
                        forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
                    },
                    skkeleton = {
                        mark = 'skkeleton',
                        matchers = {'skkeleton'},
                        sorters = {},
                    },
                    around = {
                        mark = 'A',
                    },
                })
                vim.fn['ddc#custom#patch_global']('sourceParams', {
                    nvimlsp = {
                        kindLabels = {
                            Text = "",
                            Method = "",
                            Function = "",
                            Constructor = "",
                            Field = "ﰠ",
                            Variable = "",
                            Class = "ﴯ",
                            Interface = "",
                            Module = "",
                            Property = "ﰠ",
                            Unit = "塞",
                            Value = "",
                            Enum = "",
                            Keyword = "",
                            Snippet = "",
                            Color = "",
                            File = "",
                            Reference = "",
                            Folder = "",
                            EnumMember = "",
                            Constant = "",
                            Struct = "פּ",
                            Event = "",
                            Operator = "",
                            TypeParameter = "",
                        },
                    },
                    around = {
                        maxSize = 500,
                    },
                })
                vim.fn['ddc#enable']()
                vim.fn['ddc_nvim_lsp_doc#enable']()
            end
        }

        --[[
        use {
            'hrsh7th/nvim-compe',
            config = function()
                require'compe'.setup {
                    enabled = true,
                    autocomplete = true,
                    source = {path = true, buffer = true, nvim_lsp = true},
                    preselect = 'always',
                    documentation = {border = 'single'}
                }

                -- Map compe confirm and complete functions
                vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")',
                                        {expr = true})
                vim.api.nvim_set_keymap('i', '<c-space>', 'compe#complete()',
                                        {expr = true})

                local t = function(str)
                    return vim.api.nvim_replace_termcodes(str, true, true, true)
                end

                local check_back_space = function()
                    local col = vim.fn.col('.') - 1
                    return col == 0 or
                               vim.fn.getline('.'):sub(col, col):match('%s') ~=
                               nil
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

                vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()",
                                        {expr = true})
                vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()",
                                        {expr = true})
                vim.api.nvim_set_keymap("i", "<S-Tab>",
                                        "v:lua.s_tab_complete()", {expr = true})
                vim.api.nvim_set_keymap("s", "<S-Tab>",
                                        "v:lua.s_tab_complete()", {expr = true})

            end
        }
        ]]

    end)
end

_G.setup_lsp = function()
    local nvim_lsp = require('lspconfig')
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
    end

    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    local servers = {'gopls', 'tsserver'}
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            on_attach = on_attach,
            capabilities = require'lsp-status'.capabilities,
            flags = {debounce_text_changes = 150}
        }
    end

    nvim_lsp.denols.setup {
        on_attach = on_attach,
        capabilities = require'lsp-status'.capabilities,
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

    --require'lspkind'.init()
end

-- vim:set sw=2 ts=2 sts=2:
