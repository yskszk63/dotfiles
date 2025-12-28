return {
  {
    'nvim-telescope/telescope.nvim',
    --tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    cmd = 'Telescope',
    opts = {
      pickers = {
        find_files = {
          find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
        },
      },
    },

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
