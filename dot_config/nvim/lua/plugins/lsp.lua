return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufWrite" },
    --event = "BufEnter",
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
            },
          },
        },
      })

      vim.lsp.config("jsonls", {
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
      })

      vim.lsp.config("ts_ls", {
        root_markers = {
          "package.json",
        },
        workspace_required = true,
      })

      vim.lsp.config("deno", {
        root_markers = {
          "deno.json",
        },
        workspace_required = true,
      })

      vim.lsp.config("apex_ls", {
        apex_jar_path = vim.fn.expand("$HOME/.local/bin/apex-jorje-lsp.jar"),
        apex_enable_semantic_errors = false, -- Whether to allow Apex Language Server to surface semantic errors
        apex_enable_completion_statistics = false, -- Whether to allow Apex Language Server to collect telemetry on code completion usage
        filetypes = { "apexcode", "apex" },
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
        "deno",
        --"kotlin_language_server",
        "apex_ls",
        "cssls",
        "biome",
        "lemminx",
      })
    end,
    dependencies = {
      --"simrat39/rust-tools.nvim",
      --"hrsh7th/cmp-nvim-lsp",
      --"folke/neoconf.nvim",
    },
  },
}
