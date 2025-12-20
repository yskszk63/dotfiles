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
      --{ "mrjones2014/codesettings.nvim", opts = { jsonls_integration = true }, cmd = "Codesettings" },
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-jdtls",
      --"nvim-java/nvim-java",
    },
  },
  {
    'felpafel/inlay-hint.nvim',
    event = 'LspAttach',
    config = true,
  },
}
