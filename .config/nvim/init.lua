vim.opt.mouse = ""
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes:1"
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumblend = 20
vim.opt.winblend = 20
vim.opt.clipboard = vim.opt.clipboard + { "unnamedplus" }
if vim.fn.executable "zsh" == 1 then
  vim.opt.sh = "zsh"
end

-- Revert old behavior for https://github.com/neovim/neovim/pull/13268
vim.api.nvim_del_keymap("n", "Y")

vim.g.vimsyn_embed = "l"
vim.g.mapleader = [[ ]]

local reset_term_color = function()
  -- reset term color
  vim.b.terminal_color_foreground = "#B3B1AD"
  vim.b.terminal_color_background = "#0A0E14"
  vim.b.terminal_color_0 = "#01060E"
  vim.b.terminal_color_1 = "#EA6C73"
  vim.b.terminal_color_2 = "#91B362"
  vim.b.terminal_color_3 = "#F9AF4F"
  vim.b.terminal_color_4 = "#53BDFA"
  vim.b.terminal_color_5 = "#FAE994"
  vim.b.terminal_color_6 = "#90E1C6"
  vim.b.terminal_color_7 = "#C7C7C7"
  vim.b.terminal_color_8 = "#686868"
  vim.b.terminal_color_9 = "#F07178"
  vim.b.terminal_color_10 = "#C2D94C"
  vim.b.terminal_color_11 = "#FFB454"
  vim.b.terminal_color_12 = "#59C2FF"
  vim.b.terminal_color_13 = "#FFEE99"
  vim.b.terminal_color_14 = "#95E6CB"
  vim.b.terminal_color_15 = "#FFFFFF"
end
vim.api.nvim_create_augroup("mytermcolor", {})
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = reset_term_color,
  group = "mytermcolor",
})

_G.spliterm = function()
  local w = vim.fn.winwidth(0)
  if w > (80 * 2) then
    vim.api.nvim_exec(
      [[
      rightbelow vsplit
      terminal
      startinsert
    ]],
      false
    )
  else
    vim.api.nvim_exec(
      [[
      botright split
      terminal
      startinsert
    ]],
      false
    )
  end
end

-- keymap for terminal
vim.api.nvim_set_keymap("t", "<ESC>", [[<C-\><C-n>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "@t", [[:lua _G.spliterm()<CR>]], { noremap = true })
vim.api.nvim_set_keymap("n", "@T", [[:tabnew<CR>:terminal<CR>i]], { noremap = true })

-- no term number
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.bo.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "json", "html", "javascript", "lua" },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
  end,
})

-- Disalbe embedded plugins.
vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu = 1
--vim.g.did_indent_on             = 1
--vim.g.did_load_filetypes        = 1
--vim.g.did_load_ftplugin         = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_gzip = 1
--vim.g.loaded_man                = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.skip_loading_mswin = 1

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
  local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system {
      "git",
      "clone",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    }
  end
  vim.api.nvim_command "packadd packer.nvim"

  require("packer").startup(function()
    use { "wbthomason/packer.nvim", opt = true }

    use "mattn/emmet-vim"

    use {
      "github/copilot.vim",
      opt = true,
      disable = vim.api.nvim_call_function("has", { "nvim-0.6" }) == 0,
      setup = function()
        vim.api.nvim_set_keymap(
          "i",
          "<C-L>",
          "copilot#Accept()",
          { script = true, silent = true, nowait = true, expr = true }
        )
        vim.g.copilot_no_tab_map = true
      end,
    }

    use {
      "vim-skk/skkeleton",
      requires = {
        "vim-denops/denops.vim",
      },
      disable = vim.fn.executable "deno" ~= 1,
      config = function()
        vim.api.nvim_set_keymap("i", "<C-j>", [[<Plug>(skkeleton-enable)]], {})
        vim.api.nvim_set_keymap("c", "<C-j>", [[<Plug>(skkeleton-enable)]], {})
        local skkeleton_init = function()
          vim.fn["skkeleton#config"] {
            acceptIllegalResult = true,
            tabCompletion = true,
            usePopup = true,
            eggLikeNewline = true,
            --showCandidatesCount = 65535,
            markerHenkan = "﬍ ",
            markerHenkanSelect = "ﳳ ",
          }
        end

        vim.api.nvim_create_augroup("skkeleton-initialize-pre", {})
        vim.api.nvim_create_autocmd("User", {
          pattern = "skkeleton-initialize-pre",
          callback = skkeleton_init,
          group = "skkeleton-initialize-pre",
        })
      end,
    }

    --[==[
        use {
          'EdenEast/nightfox.nvim',
          config = function()
            require'nightfox'.setup({
              options = {
                --transparent = true,
                styles = {
                  comments = "italic",
                  keywords = "bold",
                  types = "italic,bold",
                }
              },
            })

            vim.cmd('colorscheme nightfox')
          end
        }
        ]==]

    use {
      "sainnhe/sonokai",
      config = function()
        --vim.g.sonokai_style = 'andromeda'
        vim.g.sonokai_style = "default"
        vim.g.sonokai_enable_italic = 1
        vim.g.sonokai_transparent_background = 1
        vim.g.sonokai_diagnostic_text_highlight = 1
        vim.g.sonokai_diagnostic_line_highlight = 1
        vim.g.sonokai_diagnostic_virtual_text = "colored"

        vim.cmd [[colorscheme sonokai]]
      end,
    }

    use {
      "nvim-telescope/telescope.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("telescope").setup { defaults = { color_devicons = false } }
        vim.api.nvim_set_keymap(
          "n",
          "<C-p>",
          [[<cmd>lua require('telescope.builtin').find_files()<CR>]],
          { noremap = true }
        )
        vim.api.nvim_set_keymap(
          "n",
          "<Leader>b",
          [[<cmd>lua require('telescope.builtin').buffers()<cr>]],
          { noremap = true }
        )
        vim.api.nvim_set_keymap(
          "n",
          "<Leader>rg",
          [[<cmd>lua require('telescope.builtin').live_grep({ prompt_prefix="🔍" })<cr>]],
          { noremap = true }
        )
        vim.api.nvim_set_keymap(
          "n",
          "<Leader>dl",
          [[<cmd>lua require('telescope.builtin').diagnostics{}<cr>]],
          { noremap = true }
        )
        vim.api.nvim_set_keymap(
          "n",
          "<Leader>ca",
          [[<cmd>lua require('telescope.builtin').lsp_code_actions{}<cr>]],
          { noremap = true }
        )
        vim.api.nvim_set_keymap(
          "n",
          "<Leader>rf",
          [[<cmd>lua require('telescope.builtin').lsp_references{}<cr>]],
          { noremap = true }
        )
        vim.api.nvim_set_keymap(
          "n",
          "<Leader>ds",
          [[<cmd>lua require('telescope.builtin').lsp_document_symbols{}<cr>]],
          { noremap = true }
        )
      end,
    }

    use {
      "hoob3rt/lualine.nvim",
      requires = {
        "kyazdani42/nvim-web-devicons",
        "lambdalisue/battery.vim",
        "nvim-lua/lsp-status.nvim",
        "sainnhe/sonokai",
        "vim-skk/skkeleton",
        "SmiteshP/nvim-gps",
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        local gps = require "nvim-gps"
        gps.setup {}

        require("lualine").setup {
          options = {
            --theme = 'nightfox',
            theme = "sonokai",
            globalstatus = true,
          },
          sections = {
            lualine_c = {
              "filename",
              "battery#component",
              "skkeleton#mode",
              require("lsp-status").status,
              gps.get_location,
            },
            --lualine_d = { , cond = gps.is_available },
          },
        }
      end,
    }

    use {
      "sidebar-nvim/sidebar.nvim",
      config = function()
        require("sidebar-nvim").setup()
      end,
    }

    use {
      "petertriho/nvim-scrollbar",
      config = function()
        require("scrollbar").setup()
      end,
    }

    use {
      "alvarosevilla95/luatab.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
        require("luatab").setup {}
      end,
    }

    use {
      "kyazdani42/nvim-tree.lua",
      config = function()
        require("nvim-tree").setup {}
        vim.api.nvim_set_keymap("n", "<C-n>", [[:NvimTreeToggle<CR>]], { noremap = true, silent = true })
      end,
    }

    --use 'yuttie/comfortable-motion.vim'

    use {
      "declancm/cinnamon.nvim",
      config = function()
        require("cinnamon").setup {}
      end,
    }

    use "cespare/vim-toml"
    use "rust-lang/rust.vim"
    --use 'andrejlevkovitch/vim-lua-format'
    --use 'ollykel/v-vim'

    use "pantharshit00/vim-prisma"

    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

    use {
      "nvim-lua/lsp-status.nvim",
      config = function()
        require("lsp-status").register_progress()
      end,
    }

    --use {'anekos/runes-vim', opts = true}

    use { "ray-x/lsp_signature.nvim" }

    use {
      "neovim/nvim-lspconfig",
      requires = {
        "nvim-lua/lsp-status.nvim",
        "simrat39/rust-tools.nvim",
        "ray-x/lsp_signature.nvim",
        "RRethy/vim-illuminate",
      },
      config = function()
        _G.setup_lsp()
      end,
    }

    use {
      "RRethy/vim-illuminate",
      config = function()
        vim.api.nvim_command [[ hi def link LspReferenceText CursorLine ]]
        vim.api.nvim_command [[ hi def link LspReferenceWrite CursorLine ]]
        vim.api.nvim_command [[ hi def link LspReferenceRead CursorLine ]]

        vim.g.Illuminate_highlightUnderCursor = 0
        vim.cmd [[
                  augroup illuminate_augroup
                      autocmd!
                      autocmd VimEnter * hi illuminatedCurWord cterm=italic gui=italic
                  augroup END
                ]]
      end,
    }

    use {
      "Saecki/crates.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("crates").setup {}
      end,
    }

    --[==[
        use {
          'mvllow/modes.nvim',
          config = function()
            require('modes').setup()
          end
        }
        ]==]

    use {
      "yioneko/nvim-yati",
      requires = "nvim-treesitter/nvim-treesitter",
      config = function()
        require("nvim-treesitter.configs").setup {
          yati = { enable = true },
        }
      end,
    }

    --[==[
        use {
          'romgrk/nvim-treesitter-context',
          config = function()
            require'treesitter-context'.setup{}
          end
        }
        ]==]

    use {
      "j-hui/fidget.nvim",
      config = function()
        require("fidget").setup {}
      end,
    }

    use {
      "hrsh7th/nvim-cmp",
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "onsails/lspkind-nvim",
        "Saecki/crates.nvim",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
      },
      config = function()
        local cmp = require "cmp"
        local lspkind = require "lspkind"

        --lspkind.init { }

        cmp.setup {
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
              -- empty
              -- Suppress error below.
              --
              -- E5108: Error executing lua ...te/pack/packer/start/nvim-cmp/lua/cmp/config/default.lua:26:
              --   snippet engine is not configured.
            end,
          },
          mapping = cmp.mapping.preset.insert {
            ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
            ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
            ["<C-e>"] = cmp.mapping {
              i = cmp.mapping.abort(),
              c = cmp.mapping.close(),
            },
            ["<CR>"] = cmp.mapping.confirm { select = true },
          },
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "path" },
            { name = "crates" },
            --{ name = 'skkeleton' },
            { name = "nvim_lsp_signature_help" },
          }, {
            { name = "buffer" },
          }),
          formatting = {
            format = lspkind.cmp_format {},
          },
          view = {
            --entries = 'native',
          },
        }

        -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline("/", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = "nvim_lsp_document_symbol" },
          }, {
            { name = "buffer" },
          }),
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(":", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = "path" },
          }, {
            { name = "cmdline" },
          }),
        })
      end,
    }
  end)
end

_G.setup_lsp = function()
  local configs = require "lspconfig/configs"
  local nvim_lsp = require "lspconfig"

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
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    --buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    buf_set_keymap("n", "[g", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]g", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

    -- added
    require("lsp-status").on_attach(client, bufnr)
    -- lsp_signature
    --[==[
        require "lsp_signature".on_attach({
            bind = true,
            handler_opts = {
                border = "double"
            },
            hint_prefix = " ",
        }, bufnr)
        ]==]
    -- vim-illuminate
    require("illuminate").on_attach(client)
  end

  capabilities = require("cmp_nvim_lsp").update_capabilities(require("lsp-status").capabilities)

  nvim_lsp.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
  }

  nvim_lsp.sqls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
  }

  if not require("lspconfig.configs").dlsortls then
    local function virtual_text_document_handler(uri, result)
      if not result then
        return nil
      end

      for client_id, res in pairs(result) do
        local lines = vim.split(res.result, "\n")
        local bufnr = vim.uri_to_bufnr(uri)

        local current_buf = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        if #current_buf ~= 0 then
          return nil
        end

        vim.api.nvim_buf_set_lines(bufnr, 0, -1, nil, lines)
        vim.api.nvim_buf_set_option(bufnr, "readonly", true)
        vim.api.nvim_buf_set_option(bufnr, "modified", false)
        vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
        vim.lsp.buf_attach_client(bufnr, client_id)
      end
    end

    local function virtual_text_document(uri)
      local params = {
        textDocument = {
          uri = uri,
        },
      }
      local result = vim.lsp.buf_request_sync(0, "deno/virtualTextDocument", params)
      virtual_text_document_handler(uri, result)
    end

    -- https://github.com/neovim/nvim-lspconfig/blob/21102d5e3b6ffc6929d60418581ac1a29ee9eddd/lua/lspconfig/server_configurations/denols.lua#L47
    local function denols_handler(err, result, ctx)
      if not result or vim.tbl_isempty(result) then
        return nil
      end

      for _, res in pairs(result) do
        local uri = res.uri or res.targetUri
        if uri:match "^deno:" then
          virtual_text_document(uri)
          res["uri"] = uri
          res["targetUri"] = uri
        end
      end

      vim.lsp.handlers[ctx.method](err, result, ctx)
    end

    require("lspconfig.configs").dlsortls = {
      default_config = {
        init_options = {
          enable = true,
          lint = false,
          unstable = true,
          hostInfo = "neovim",
        },
        cmd = { "dlsortls" },
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        root_dir = require("lspconfig.util").root_pattern(
          "tsconfig.json",
          "package.json",
          "jsconfig.json",
          ".git",
          "deno.json",
          "deno.jsonc"
        ),
        handlers = {
          ["textDocument/definition"] = denols_handler,
          ["textDocument/references"] = denols_handler,
        },
      },
    }
  end
  nvim_lsp.dlsortls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
  }

  require("rust-tools").setup {
    autostart = false,
    server = {
      on_attach = on_attach,
      flags = { debounce_text_changes = 150 },
      settings = { ["rust-analyzer"] = { diagnostics = { enable = false } } },
      capabilities = capabilities,
    },
  }

  nvim_lsp.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
  }

  nvim_lsp.intelephense.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
  }

  nvim_lsp.prismals.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
  }

  -- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#change-diagnostic-symbols-in-the-sign-column-gutter
  local signs = {
    Error = " ",
    Warning = " ",
    Hint = " ",
    Information = " ",
  }

  for type, icon in pairs(signs) do
    local hl = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end
end

-- vim:set sw=2 ts=2 sts=2:
