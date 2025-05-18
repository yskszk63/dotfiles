local opts = { noremap = true, silent = true }

-- Terminal
vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], opts)

vim.keymap.set("n", "@t", function()
  local w = vim.fn.winwidth(0)
  if w > (80 * 2) then
    vim.api.nvim_exec(
      [[
      rightbelow vsplit
      terminal
      startinsert
    ]],
      false
    )
  else
    vim.api.nvim_exec(
      [[
      botright split
      terminal
      startinsert
    ]],
      false
    )
  end
end, opts)
vim.keymap.set("n", "@T", [[:tabnew<CR>:terminal<CR>i]], opts)
