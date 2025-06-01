return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    event = { 'BufRead', 'BufNewFile', 'InsertEnter' },
    config = function()
      require'nvim-treesitter'.install {
        "go",
        "rust",
        "javascript",
        "typescript",
        "tsx",
      }

      --vim.opt.foldenable = false

      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          "go",
          "rust",
          "javascript",
          "typescript",
          "typescriptreact",
        },
        callback = function()
          vim.treesitter.start()
          vim.wo.foldtext = ""
          vim.wo.foldmethod = "expr"
          vim.wo.foldlevel = 99
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end

    --[==[
    config = function()
      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = false,
        },
      }
    end,
    ]==]
  },
}
