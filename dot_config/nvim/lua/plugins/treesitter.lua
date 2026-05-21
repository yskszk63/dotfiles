return {
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   lazy = false,
  --   build = ":TSUpdate",
  --   config = function ()
  --     require("nvim-treesitter").setup({})
  --     vim.api.nvim_create_autocmd("FileType", {
  --       callback = function ()
  --         if pcall(vim.treesitter.start) ~= true then
  --           return
  --         end
  --         --vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  --       end
  --     })
  --   end
  -- },
  --

  {
    "romus204/tree-sitter-manager.nvim",
    dependencies = {}, -- tree-sitter CLI must be installed system-wide
    config = function()
      require("tree-sitter-manager").setup({
        -- Default Options
        -- ensure_installed = {}, -- list of parsers to install at the start of a neovim session
        -- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
        -- auto_install = false, -- if enabled, install missing parsers when editing a new file
        -- highlight = true, -- treesitter highlighting is enabled by default
        -- languages = {}, -- override or add new parser sources
        -- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
        -- query_dir = vim.fn.stdpath("data") .. "/site/queries",
      })
    end
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    config = true,
  },
}
