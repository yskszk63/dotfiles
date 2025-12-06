local function load_dropin_settings(server_name)
  local ok, mod = pcall(require, "lsp.settings." .. server_name)
  if not ok then
    return nil
  end
  if type(mod) ~= "table" then
    return nil
  end
  return mod
end

local function apply_dropin_settings(config)
  local dropin = load_dropin_settings(config.name)

  if dropin == nil then
    return
  end

  if config.settings == nil then
    config.settings = dropin
  else
    config.settings = vim.tbl_deep_extend(
      "force",
      config.settings,
      dropin
    )
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufWrite" },
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
      })

      vim.lsp.config('*', {
        before_init = function(_, config)
          apply_dropin_settings(config)

          --local codesettings = require('codesettings')
          --config = codesettings.with_local_settings(config.name, config)
        end,
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
}
