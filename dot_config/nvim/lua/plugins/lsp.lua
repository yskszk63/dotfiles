return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufWrite" },
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
      })

      vim.lsp.enable({
        "gopls",
        "rust_analyzer",
        "pyright",
        "zls",
        "jdtls",
        --"solargraph",
        --"efm",
        --"terraformls",
        "yamlls",
        "jsonls",
        "eslint",
        "ts_ls",
        "denols",
        --"kotlin_language_server",
        --"apex_ls",
        "cssls",
        "biome",
        "lemminx",
        "lua_ls",
      })
    end,
    dependencies = {
      --"simrat39/rust-tools.nvim",
      --"hrsh7th/cmp-nvim-lsp",
      --{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-jdtls",
      --"nvim-java/nvim-java",
    },
  },

  {
    "mrjones2014/codesettings.nvim",
    config = function ()
      local codesettings = require('codesettings')
      codesettings.setup({})
      vim.lsp.config('*', {
        before_init = function(_, config)
          codesettings.with_local_settings(config.name, config)
        end,
      })
    end
  },

  {
    'felpafel/inlay-hint.nvim',
    event = 'LspAttach',
    config = true,
  },

  {
    'dnlhc/glance.nvim',
    cmd = 'Glance',
    keys = {
      { "gD", "<CMD>Glance definitions<CR>", mode = { "n" } },
      { "gR", "<CMD>Glance references<CR>", mode = { "n" } },
      { "gY", "<CMD>Glance type_definitions<CR>", mode = { "n" } },
      { "gM", "<CMD>Glance implementations<CR>", mode = { "n" } },
    },
  },

  {
    "bassamsdata/namu.nvim",
    opts = {
      global = { },
      namu_symbols = { -- Specific Module options
        options = {},
      },
    },
    keys = {
      { "<LEADER>ss", "<CMD>Namu symbols<cr>", mode = { "n" }, desc = "Jump to LSP symbol", silent = true },
      { "<LEADER>sw", "<CMD>Namu workspace<cr>", mode = { "n" }, desc = "LSP Symbols - Workspace", silent = true },
    },
  },
}
