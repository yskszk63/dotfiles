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

  {
    'alvarosevilla95/luatab.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = true,
  },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
    opts = {
      win_options = {
        number = false,
        relativenumber = false,
        signcolumn = "yes:2",
      },
      keymaps = {
        ["<C-p>"] = false,
      },
    },
    keys = {
      { "-", "<CMD>Oil<CR>", mode = { "n" } },
      { "<c-n>", "<CMD>Oil --float<CR>", mode = { "n" } },
    },
  },

  {
    "benomahony/oil-git.nvim",
    dependencies = { "stevearc/oil.nvim" },
  },

  {
    "JezerM/oil-lsp-diagnostics.nvim",
    dependencies = { "stevearc/oil.nvim" },
    opts = {}
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

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      presets = {
        --bottom_search = true,
        --command_palette = true,
        --long_message_to_split = true,
        --inc_rename = false,
        lsp_doc_border = true,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- "rcarriga/nvim-notify",
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 500,
    },
  },

  {
    "OXY2DEV/markview.nvim",
    lazy = false,
  },
}
