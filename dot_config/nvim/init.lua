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

-- https://www.reddit.com/r/neovim/comments/tgyddx/heres_a_snippet_for_thicker_vertical_and/
vim.opt.fillchars = {
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft  = '┫',
  vertright = '┣',
  verthoriz = '╋',
}

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

vim.api.nvim_set_keymap("t", [[<S-Space>]], [[<Space>]], { noremap = true })

-- no term number
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
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

-- https://unix.stackexchange.com/questions/609612/disable-auto-tabs-when-putting-your-first-comment-in-a-yaml-files-with-vim-edito
--autocmd BufEnter *.yaml,*.yml :set indentkeys-=0#
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.yaml", "*.yml" },
  callback = function()
    vim.bo.indentkeys = vim.bo.indentkeys:gsub('0#', '')
  end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

function lspconfig()
  require("neoconf").setup({})
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  local nvim_lsp = require "lspconfig"

  nvim_lsp.gopls.setup {
    capabilities = capabilities,
  }

  require("rust-tools").setup {
    server = {
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          diagnostics = {
            enable = true,
          },
          imports = {
            granularity = {
              group = "module",
            },
          },
        }
      },
    },
  }
  --[==[
  nvim_lsp.rust_analyzer.setup {
    capabilities = capabilities,
  }
  ]==]

  nvim_lsp.pyright.setup {
    capabilities = capabilities,
  }

  nvim_lsp.zls.setup {
    capabilities = capabilities,
  }

  nvim_lsp.jdtls.setup {
    capabilities = capabilities,
  }

  nvim_lsp.solargraph.setup {
    capabilities = capabilities,
  }

  nvim_lsp.efm.setup {
    capabilities = capabilities,
    filetypes = {"yaml"}, -- TODO define cfn
    settings = {
      rootMarkers = {".git/"},
      languages = {
        yaml = {
          {
            lintCommand = "cfn-lint",
            lintStdin = true,
          }
        },
      },
    },
  }

  nvim_lsp.terraformls.setup {
    capabilities = capabilities,
  }

  nvim_lsp.yamlls.setup {
    capabilities = capabilities,
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
        },
      },
    },
  }

  nvim_lsp.jsonls.setup {
    capabilities = capabilities,
    settings = {
      json = {
        schemas = {
            {
              fileMatch = { "package.json" },
              url = "https://json.schemastore.org/package.json",
            },
            {
              fileMatch = { "tsconfig*.json" },
              url = "https://json.schemastore.org/tsconfig.json",
            },
        }
      }
    },
  }

  nvim_lsp.eslint.setup {
    capabilities = capabilities,
  }

  -- https://deno.land/manual@v1.16.3/getting_started/setup_your_environment#neovim-06-and-nvim-lspconfig
  --
  --[==[
  nvim_lsp.denols.setup {
    capabilities = capabilities,
    root_dir = nvim_lsp.util.root_pattern("deno.json"),
  }
  ]==]

  nvim_lsp.ts_ls.setup {
    capabilities = capabilities,
    root_dir = nvim_lsp.util.root_pattern("package.json"),
    single_file_support = false,
  } 

  nvim_lsp.kotlin_language_server.setup {
    capabilities = capabilities,
  }

  nvim_lsp.apex_ls.setup {
    capabilities = capabilities,
    apex_jar_path = vim.fn.expand("$HOME/.local/bin/apex-jorje-lsp.jar"),
    apex_enable_semantic_errors = false, -- Whether to allow Apex Language Server to surface semantic errors
    apex_enable_completion_statistics = false, -- Whether to allow Apex Language Server to collect telemetry on code completion usage
    filetypes = { "apexcode", "apex" },
  }

  nvim_lsp.cssls.setup {
    capabilities = capabilities,
  }
end

require("lazy").setup {
  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    config = function()
      --vim.g.sonokai_style = 'andromeda'
      vim.g.sonokai_style = "default"
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_transparent_background = 1
      vim.g.sonokai_diagnostic_text_highlight = 1
      vim.g.sonokai_diagnostic_line_highlight = 1
      vim.g.sonokai_diagnostic_virtual_text = "colored"
      vim.g.sonokai_menu_selection_background = "green"

      vim.cmd [[colorscheme sonokai]]
    end,
  },

  {
    "vim-denops/denops.vim",
    enabled = vim.fn.executable "deno" == 1,
    event = { 'VeryLazy' },
    dependencies = {
      "vim-skk/skkeleton",
    },
  },

  {
    "vim-skk/skkeleton",
    enabled = vim.fn.executable "deno" == 1,
    keys = {
      { "<C-j>", "<Plug>(skkeleton-enable)", mode = { "i", "c" } },
    },
    config = function()
      local skkeleton_init = function()
        vim.fn["skkeleton#config"] {
          acceptIllegalResult = true,
          usePopup = true,
          eggLikeNewline = true,
          --markerHenkan = "﬍ ",
          --markerHenkanSelect = "ﳳ ",
          globalDictionaries = {
            "/usr/share/skk/SKK-JISYO.L",
          },
        }
      end

      vim.api.nvim_create_augroup("skkeleton-initialize-pre", {})
      vim.api.nvim_create_autocmd("User", {
        pattern = "skkeleton-initialize-pre",
        callback = skkeleton_init,
        group = "skkeleton-initialize-pre",
      })
    end,
  },

  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = function()
      require'telescope'.setup {
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      }
    end,
    keys = {
      { "<C-p>", "<cmd>lua require('telescope.builtin').find_files()<CR>" },
      { "<Leader>b", "<cmd>lua require('telescope.builtin').buffers()<CR>" },
      { "<Leader>rg", "<cmd>lua require('telescope.builtin').live_grep({ prompt_prefix='🔍' })<CR>" },
      { "<Leader>dl", "<cmd>lua require('telescope.builtin').diagnostics{}<CR>" },
      { "<Leader>rf", "<cmd>lua require('telescope.builtin').lsp_references{}<CR>" },
      { "<Leader>ds", "<cmd>lua require('telescope.builtin').lsp_document_symbols{}<CR>" },
    },
  },

  {
    "hoob3rt/lualine.nvim",
    config = function()
      require'lualine'.setup {
        options = {
          theme = "sonokai",
          globalstatus = true,
        },
        sections = {
          lualine_c = {
            "filename",
            "skkeleton#mode",
          },
        },
      }
    end,
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = "BufEnter",
    config = function()
      lspconfig()
      vim.api.nvim_command("LspStart")
    end,
    dependencies = {
      "simrat39/rust-tools.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "folke/neoconf.nvim",
    },
  },

  {
    "glepnir/lspsaga.nvim",
    event = "BufRead",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require"lspsaga".setup {
        lightbulb = {
          enable = false,
        },
      }
      --vim.wo.stl = require('lspsaga.symbolwinbar'):get_winbar()
    end,
    keys = {
      { "gh", "<cmd>Lspsaga lsp_finder<CR>" },
      { "<leader>ca", "<cmd>Lspsaga code_action<CR>", mode = { "n", "v" } },
      --{ "gr", "<cmd>Lspsaga rename<CR>" },
      { "gd", "<cmd>Lspsaga peek_definition<CR>" },
      { "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>" },
      --{ "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>" },
      --{ "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>" },
      { "[g", "<cmd>Lspsaga diagnostic_jump_prev<CR>" },
      { "]g", "<cmd>Lspsaga diagnostic_jump_next<CR>" },
      { "<leader>o", "<cmd>Lspsaga outline<CR>" },
      { "K", "<cmd>Lspsaga hover_doc<CR>" },
      { "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>" },
      { "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>" },
      { "<A-d>", "<cmd>Lspsaga term_toggle<CR>", mode = { "n", "v" } },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/vim-vsnip",
      "onsails/lspkind.nvim",
      "saecki/crates.nvim",
    },
    config = function()
      local cmp = require "cmp"
      local lspkind = require "lspkind"

      cmp.setup {
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
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
      cmp.setup.cmdline({"/", "?"}, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
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
  },

  {
    "saecki/crates.nvim",
    config = true,
  },

  {
    "petertriho/nvim-scrollbar",
    config = true,
  },

  {
    "alvarosevilla95/luatab.nvim",
    config = true,
  },

  {
    "kyazdani42/nvim-tree.lua",
    keys = {
      { "<C-n>", ":NvimTreeToggle<CR>" }
    },
    config = true,
  },

  {
    "declancm/cinnamon.nvim",
    enabled = false,
    config = true,
  },

  -- "cespare/vim-toml",
  "rust-lang/rust.vim",
  "ziglang/zig.vim",

  {
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
    end
  },

  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {
      -- options
    },
  },

  {
    "shellRaining/hlchunk.nvim",
    event = { "UIEnter" },
    config = function()
      require("hlchunk").setup({})
    end
  },

  {
    "udalov/kotlin-vim",
  },
}

