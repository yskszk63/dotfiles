return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
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
  },

  --[==[
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local map = vim.api.nvim_set_keymap
      local opts = { noremap = true, silent = true }

      -- Move to previous/next
      map("n", "<C-j>", "<Cmd>BufferPrevious<CR>", opts)
      map("n", "<C-k>", "<Cmd>BufferNext<CR>", opts)
      -- Close buffer
      map("n", "<leader>e", "<Cmd>BufferClose<CR>", opts)
    end,
  },
  ]==]
  {
    'alvarosevilla95/luatab.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = true,
  },

  {
    "kyazdani42/nvim-tree.lua",
    keys = {
      { "<C-n>", ":NvimTreeToggle<CR>" },
    },
    config = true,
  },

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
    opts = { },
  },

  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end
  },
}
