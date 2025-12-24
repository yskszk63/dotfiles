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
}
