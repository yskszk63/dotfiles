return {
  {
    'nvim-telescope/telescope.nvim',
    --tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    cmd = 'Telescope',
    config = function()
      require'telescope'.setup {
        pickers = {
          find_files = {
            -- hidden = true,
            find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
          },
        },
      }

      -- https://github.com/nvim-telescope/telescope.nvim/issues/3436#issuecomment-2756267300
      vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopeFindPre",
        callback = function()
          vim.api.nvim_create_autocmd("WinLeave", {
            once = true,
            callback = function()
              vim.opt_local.winborder = "rounded"
            end,
          })
        end,
      })

    end,
    keys = {
      { "<C-p>", "<cmd>lua require('telescope.builtin').find_files()<CR>" },
      { "<Leader>b", "<cmd>lua require('telescope.builtin').buffers()<CR>" },
      { "<Leader>rg", "<cmd>lua require('telescope.builtin').live_grep({ prompt_prefix='🔍 ' })<CR>" },
      { "<Leader>dl", "<cmd>lua require('telescope.builtin').diagnostics{}<CR>" },
      { "<Leader>rf", "<cmd>lua require('telescope.builtin').lsp_references{}<CR>" },
      { "<Leader>ds", "<cmd>lua require('telescope.builtin').lsp_document_symbols{}<CR>" },
    },
  },
}
