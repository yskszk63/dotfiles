return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function ()
      require("nvim-treesitter").setup({})
      vim.api.nvim_create_autocmd("FileType", {
        callback = function ()
          if pcall(vim.treesitter.start) ~= true then
            return
          end
          --vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      })
    end
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    config = true,
  },
}
